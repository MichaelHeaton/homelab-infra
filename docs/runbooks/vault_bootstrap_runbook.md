# Vault Bootstrap Runbook [Synology NAS, Portainer stack]

**Scope:** minimal, temporary Vault with Raft storage and TLS. Single node. Non-root uid,gid.  
**Audience:** SRE on NAS01.  
**Hostname:** `vault` and `vault.SpecterRealm.com`.

---

## TL,DR

- [ ] Confirm container is up, hostname is `vault`, web UI loads
- [ ] Set env in the Vault container: `VAULT_ADDR`, `VAULT_CACERT`, `VAULT_TOKEN`
- [ ] If first run, **init** then **unseal** with 3 keys
- [ ] Run `scripts/vault/init.sh` bootstrap (or `/tmp/init.sh` inside container if testing), or execute equivalent manual steps below
- [ ] Store unseal shares and root token in M365 Secure Notes
- [ ] Enable audit to file, seed initial secrets, take a Raft snapshot
- [ ] Add the backup paths to Hyper Backup

---

## Constants

- Vault URL: `https://vault.SpecterRealm.com:8200`
- In-container URL: `https://vault:8200`
- CA and certs in container: `/pki/ca.pem`, `/pki/vault.crt`, `/pki/vault.key`
- Data: `/volume1/docker/appdata/vault/data`
- Audit: `/volume1/docker/appdata/vault/audit`
- Config: `/volume1/docker/appdata/vault/config/vault.hcl`
- Run as `user: "1030:100"`, `SKIP_SETCAP=true`, `disable_mlock=true`

---

## Prerequisites

- Portainer stack deployed with volumes bound to the paths above.
- TLS files exist and are mounted as files, not a directory.
- Container hostname set to `vault` in the stack.
- The CA that signed `vault.crt` is present at `/pki/ca.pem` in the container.

**Sanity:**
```sh
# inside the vault container shell
export VAULT_ADDR=https://vault:8200
export VAULT_CACERT=/pki/ca.pem
vault status || true
```

---

## Initialize and Unseal

**Initialize** on first ever run:
```sh
vault operator init -key-shares=5 -key-threshold=3
# Save: 5 unseal keys, root token. Store in M365.
```

**Unseal**:
```sh
vault operator unseal    # run 3 times with different keys
vault status             # should show Sealed=false, Mode=active
```

**Lost root token? Generate a new one**:
```sh
vault operator generate-root -generate-otp
vault operator generate-root -init -otp=<otp>   # copy Nonce
vault operator generate-root -nonce=<nonce>     # repeat 3 times, paste different unseal keys
vault operator generate-root -decode=<encoded_token> -otp=<otp>  # new root token
```

---

## One-shot Bootstrap Script

Create and run the script **inside the vault container**.

```sh
cat > /tmp/init.sh <<'EOF'
#!/usr/bin/env sh
set -euo pipefail

VAULT_ADDR="${VAULT_ADDR:-https://vault:8200}"
VAULT_CACERT="${VAULT_CACERT:-/pki/ca.pem}"
ROOT_TOKEN="${VAULT_TOKEN:-}"

CF_API_TOKEN="${CF_API_TOKEN:-}"          # optional seed
PG_USER="${PG_USER:-svc_app}"
PG_PASS="${PG_PASS:-}"                    # optional seed
PG_URL="${PG_URL:-postgres://db:5432/app}"

if [ -z "${ROOT_TOKEN}" ]; then
  echo "ERROR: VAULT_TOKEN (root) not set" >&2
  exit 1
fi

export VAULT_ADDR VAULT_CACERT VAULT_TOKEN="${ROOT_TOKEN}"

vault status || true

# Enable KV v2
vault secrets list -format=json | grep -q '"kv/":' || \
  vault secrets enable -path=kv kv-v2

# Policies
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

# Auth
vault auth list -format=json | grep -q '"userpass/":' || \
  vault auth enable userpass

ADMIN_PW="${ADMIN_PW:-$(head -c 18 /dev/urandom | base64)}"
vault write auth/userpass/users/admin password="${ADMIN_PW}" policies=admin
echo "BOOTSTRAP_ADMIN_USER=admin"
echo "BOOTSTRAP_ADMIN_PASS=${ADMIN_PW}"

if [ -n "${PG_PASS}" ] || [ -n "${CF_API_TOKEN}" ]; then
  SVC_PW="${SVC_PW:-$(head -c 18 /dev/urandom | base64)}"
  vault write auth/userpass/users/svc password="${SVC_PW}" policies=service
  echo "SERVICE_USER=svc"
  echo "SERVICE_PASS=${SVC_PW}"
fi

# Audit
mkdir -p /vault/audit
vault audit list -format=json | grep -q '"file/":' || \
  vault audit enable file file_path=/vault/audit/audit.log

# Seed secrets
[ -n "${CF_API_TOKEN}" ] && vault kv put kv/cloudflare/api token="${CF_API_TOKEN}" && echo "Seeded: kv/cloudflare/api"
[ -n "${PG_PASS}" ] && vault kv put kv/db/postgres username="${PG_USER}" password="${PG_PASS}" url="${PG_URL}" && echo "Seeded: kv/db/postgres"

# Smoke and snapshot
vault kv put kv/test hello=world >/dev/null
vault kv get kv/test >/dev/null && echo "KV test OK"

SNAP=/vault/data/bootstrap-$(date +%Y%m%d-%H%M%S).snap
vault operator raft snapshot save "${SNAP}"
echo "Snapshot: ${SNAP}"
EOF

chmod +x /tmp/init.sh

# Required: export VAULT_TOKEN to your current root token
VAULT_TOKEN=<root-token-here> /tmp/init.sh
```

**Optional seeds:**
```sh
export CF_API_TOKEN=<CF token>           # optional
export PG_PASS=<postgres password>       # optional
export PG_USER=svc_app
export PG_URL="postgres://host:5432/app"
VAULT_TOKEN=<root-token> /tmp/init.sh
```

---

## Manual Minimal Steps (if not using script)

```sh
export VAULT_ADDR=https://vault:8200
export VAULT_CACERT=/pki/ca.pem
export VAULT_TOKEN=<root>

vault secrets enable -path=kv kv-v2

cat >/tmp/admin.hcl <<'EOF'
path "sys/*"  { capabilities = ["create","read","update","delete","list","sudo"] }
path "auth/*" { capabilities = ["create","read","update","delete","list","sudo"] }
path "kv/*"   { capabilities = ["create","read","update","delete","list"] }
EOF
vault policy write admin /tmp/admin.hcl

vault auth enable userpass
ADMIN_PW="$(head -c 18 /dev/urandom | base64)"; echo "admin: ${ADMIN_PW}"
vault write auth/userpass/users/admin password="${ADMIN_PW}" policies=admin

mkdir -p /vault/audit
vault audit enable file file_path=/vault/audit/audit.log
```

---

## Backups

Include in Hyper Backup:
- `/volume1/docker/appdata/vault/data`  [Raft, snapshots]
- `/volume1/docker/appdata/vault/audit`
- `/volume1/docker/appdata/vault/config`
- `/volume1/docker/appdata/pki`  [include `ca.key` if you want to reissue]

Run a snapshot after bootstrap:
```sh
vault operator raft snapshot save /vault/data/post-bootstrap.snap
```

---

## What to save

- Unseal key shares: all 5. Threshold 3.
- Current root token.
- If used: bootstrap `admin` userpass and `svc` userpass credentials.
- Snapshot file names and locations.

---

## Troubleshooting quick hits

- **permission denied /vault/data/vault.db**  
  Fix host ownership to 1030:100, ensure parents 755, data 700. Remove stale `vault.db`, `raft/`. Clear DSM ACLs if present.

- **mlock failures**  
  Set `disable_mlock = true` in `vault.hcl`. For ulimit route, add `ulimits: { memlock: -1 }` and keep `IPC_LOCK`.

- **TLS cert not found or permission denied**  
  Bind files individually:
  ```
  - /volume1/.../pki/vault.crt:/pki/vault.crt:ro
  - /volume1/.../pki/vault.key:/pki/vault.key:ro
  - /volume1/.../pki/ca.pem:/pki/ca.pem:ro
  ```
  Ensure `/pki/vault.key` is readable by uid 1030.

- **x509 cannot validate 127.0.0.1**  
  Use `https://vault:8200` inside the container or add IP SANs when minting the cert.

- **CAP_SETFCAP errors when running as 1030**  
  Set `SKIP_SETCAP=true` in environment.

- **403 permission denied on CLI**  
  `VAULT_TOKEN` not set or wrong. Re-export it or generate a new root with `generate-root`.

---

## Restore Runbook

1. Restore backup folders to the same paths.  
2. Redeploy Portainer stack.  
3. Unseal with any 3 shares.  
4. `export VAULT_ADDR=https://vault:8200 VAULT_CACERT=/pki/ca.pem`  
5. `vault status` should show active.  
6. Re-enable audit if the path changed.  
7. Rotate root token. Optionally disable `userpass` when OIDC is ready.

---
