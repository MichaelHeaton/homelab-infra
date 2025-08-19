#!/usr/bin/env sh
set -euo pipefail

# ---- Config ----
VAULT_ADDR="${VAULT_ADDR:-https://vault:8200}"
VAULT_CACERT="${VAULT_CACERT:-/pki/ca.pem}"
ROOT_TOKEN="${VAULT_TOKEN:-}"

# Optional seed secrets
CF_API_TOKEN="${CF_API_TOKEN:-}"          # e.g. set before run: export CF_API_TOKEN=...
PG_USER="${PG_USER:-svc_app}"
PG_PASS="${PG_PASS:-}"
PG_URL="${PG_URL:-postgres://db:5432/app}"

# ---- Checks ----
if [ -z "${ROOT_TOKEN}" ]; then
  echo "ERROR: VAULT_TOKEN (root) not set" >&2
  exit 1
fi

export VAULT_ADDR VAULT_CACERT VAULT_TOKEN="${ROOT_TOKEN}"

echo "== Status =="
vault status || true

# ---- Enable KV v2 (idempotent) ----
if ! vault secrets list -format=json | grep -q '"kv/":'; then
  vault secrets enable -path=kv kv-v2
else
  echo "kv already enabled"
fi

# ---- Policies ----
cat >/tmp/admin.hcl <<'POLICY'
path "sys/*"  { capabilities = ["create","read","update","delete","list","sudo"] }
path "auth/*" { capabilities = ["create","read","update","delete","list","sudo"] }
path "kv/*"   { capabilities = ["create","read","update","delete","list"] }
POLICY
vault policy write admin /tmp/admin.hcl

cat >/tmp/service.hcl <<'POLICY'
path "kv/data/*"     { capabilities = ["read"] }
path "kv/metadata/*" { capabilities = ["list"] }
POLICY
vault policy write service /tmp/service.hcl

# ---- Auth: userpass for bootstrap ----
if ! vault auth list -format=json | grep -q '"userpass/":'; then
  vault auth enable userpass
else
  echo "userpass already enabled"
fi

# admin bootstrap user (random pw if not provided)
ADMIN_PW="${ADMIN_PW:-$(head -c 18 /dev/urandom | base64)}"
vault write auth/userpass/users/admin password="${ADMIN_PW}" policies=admin
echo "BOOTSTRAP_ADMIN_USER=admin"
echo "BOOTSTRAP_ADMIN_PASS=${ADMIN_PW}"

# optional service user
if [ -n "${PG_PASS}" ] || [ -n "${CF_API_TOKEN}" ]; then
  SVC_PW="${SVC_PW:-$(head -c 18 /dev/urandom | base64)}"
  vault write auth/userpass/users/svc password="${SVC_PW}" policies=service
  echo "SERVICE_USER=svc"
  echo "SERVICE_PASS=${SVC_PW}"
fi

# ---- Audit to file ----
mkdir -p /vault/audit
if ! vault audit list -format=json | grep -q '"file/":'; then
  vault audit enable file file_path=/vault/audit/audit.log
else
  echo "audit file already enabled"
fi

# ---- Seed secrets (optional) ----
if [ -n "${CF_API_TOKEN}" ]; then
  vault kv put kv/cloudflare/api token="${CF_API_TOKEN}"
  echo "Seeded: kv/cloudflare/api"
fi
if [ -n "${PG_PASS}" ]; then
  vault kv put kv/db/postgres username="${PG_USER}" password="${PG_PASS}" url="${PG_URL}"
  echo "Seeded: kv/db/postgres"
fi

# ---- Smoke test ----
vault kv put kv/test hello=world >/dev/null
vault kv get -format=json kv/test | grep '"hello": "world"' >/dev/null && echo "KV test OK"

# ---- Snapshot ----
SNAP=/vault/data/bootstrap-$(date +%Y%m%d-%H%M%S).snap
vault operator raft snapshot save "${SNAP}"
echo "Snapshot: ${SNAP}"

echo "Done."