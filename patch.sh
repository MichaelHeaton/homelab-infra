#!/usr/bin/env bash
set -euo pipefail
#
# --- AI Context helpers -------------------------------------------------------
usage() {
  cat <<'USAGE'
Usage: ./patch.sh [--ai "text"] [--verify-map] [--nav] [--full]

  --ai "text"      Append a decision entry to docs/ai-context.md and exit.
  --verify-map     Update the auto-generated Repository Map block only, then exit.
  --nav            Rebuild mkdocs.yml navigation and repo map, then exit.
  --full           Perform the full maintenance flow (default if no flag given).
USAGE
}
ensure_file() {
  # ensure_file <path> <header_title>
  local path="$1"; shift
  local title="$1"; shift
  if [ ! -f "$path" ]; then
    mkdir -p "$(dirname "$path")"
    cat > "$path" <<EOF
---
icon: material/robot-happy
---
# $title

This page holds durable context for collaborating with AI on this repo. Entries are **appended** and never auto-deleted.

EOF
    echo "Created file: $path"
  fi
}

append_ai_decision() {
  # append_ai_decision <text>
  local msg="$*"
  local dest="docs/ai-context.md"
  ensure_file "$dest" "AI Context (Decisions & Repo Map)"
  {
    printf '\n## Decision — %s\n\n' "$(date -u '+%Y-%m-%d %H:%M:%SZ')"
    printf '%s\n' "$msg"
    :
  } >> "$dest"
  echo "AI Context: appended decision to $dest"
}

upsert_repo_map() {
  # Writes/updates the auto-generated repo map section between markers
  local dest="docs/ai-context.md"
  ensure_file "$dest" "AI Context (Decisions & Repo Map)"

  # Generate checks
  local check_patchsh="❌"; [ -x "./patch.sh" ] && check_patchsh="✅"
  local check_mkdocs="❌"; [ -r "./mkdocs.yml" ] && check_mkdocs="✅"
  local check_docs="❌"; [ -d "./docs" ] && check_docs="✅"
  local check_workflow="❌"; [ -f ".github/workflows/pages.yml" ] && check_workflow="✅"
  local check_runbooks="❌"; ls docs/runbooks/*.md >/dev/null 2>&1 && check_runbooks="✅"

  local tmp="$(mktemp)"
  cat > "$tmp" <<'EOF'
<!-- BEGIN: REPO_MAP (auto-generated; do not edit by hand) -->

## Repository Map (Auto-generated)

This section is rewritten by `patch.sh` on each run to reflect the current layout and health checks. Other sections above/below are preserved.

### Key Directories
- `docs/` — MkDocs content source.
  - `docs/01-Hardware.md` — Hardware requirements and planning.
  - `docs/02-Workstation-Setup.md` — Laptop/desktop tooling installs and verification.
  - `docs/03-Cloud-Accounts-and-Foundations.md` — HCP Terraform and foundational services bootstrap.
  - `docs/04-Network-Setup.md` — Network setup and Terraform imports.
  - `docs/05-NAS-Setup.md` — Storage and backup services.
  - `docs/06-Proxmox-Cluster-Setup.md` — Proxmox cluster deployment.
  - `docs/07-CI-CD-for-Terraform.md` — CI/CD pipelines for Terraform workflows.
  - `docs/08-Image-Factory.md` — Image building and automation.
  - `docs/09-Core-Infra-VMs.md` — Core VM deployments (Jump Box, PBS, etc).
  - `docs/10-Docker-Swarm-Cluster.md` — Docker Swarm cluster setup.
  - `docs/11-Traefik-Authentik-Public-DNS-VPN.md` — Reverse proxy, SSO, public DNS, VPN.
  - `docs/12-Integration-Pass-1.md` — First integration pass (import resources to TF/Vault/Consul).
  - `docs/13-Migrations-and-Refactor.md` — State migrations and refactor.
  - `docs/14-Observability-and-Alerting.md` — Monitoring, logging, and alerting.
  - `docs/15-Ops-Readiness.md` — Ops readiness, DR, runbooks, SLOs.
  - `docs/16-Local-DNS.md` — Local DNS (Pi-hole, CoreDNS, Bind).
  - `docs/17-DMZ-and-Routing.md` — DMZ setup and routing policies.
  - `docs/18-Public-Status-Page-and-Alerting.md` — Public status page and alerting.
  - `docs/19-Workloads.md` — Workloads (Plex, Game Servers, Family Photos).
  - `docs/20-Graduation.md` — Graduation and wrap-up.
  - `docs/21-Lab-and-Service-Ideas.md` — Backlog of future labs and service ideas.
  - `docs/runbooks/` — Operational runbooks for maintenance tasks.
  - `docs/glossary.md` — DAT (Define Acronyms & Terms).
  - `docs/ai-context.md` — AI decision log and repo map.
- `.github/workflows/pages.yml` — GitHub Pages build & deploy pipeline.
- `mkdocs.yml` — Site configuration (theme, nav, plugins).
- `patch.sh` — Idempotent repo maintainer (icons, nav, AI context, etc).

### Expected Files & Permissions
| Item | Purpose | Exists | Perms |
|---|---|---|---|
| `patch.sh` | Repo maintainer script | __CHECK_PATCH__ | executable: __PERM_PATCH__ |
| `mkdocs.yml` | MkDocs site config | __CHECK_MKDOCS__ | readable |
| `docs/` | Documentation root | __CHECK_DOCS__ | readable |
| `.github/workflows/pages.yml` | Pages CI workflow | __CHECK_WORKFLOW__ | readable |
| `docs/runbooks/*.md` | Runbooks content | __CHECK_RUNBOOKS__ | readable |

### Quick Tests
- Serve docs locally: `source .venv/bin/activate && mkdocs serve -a 0.0.0.0:8000`
- Build static site: `mkdocs build`
- Verify theme dark default + icons load on home page.

<!-- END: REPO_MAP -->
EOF

  # Fill dynamic checks (BSD/GNU sed compatible)
  if ! sed -i '' \
      -e "s/__CHECK_PATCH__/$check_patchsh/" \
      -e "s/__PERM_PATCH__/$check_patchsh/" \
      -e "s/__CHECK_MKDOCS__/$check_mkdocs/" \
      -e "s/__CHECK_DOCS__/$check_docs/" \
      -e "s/__CHECK_WORKFLOW__/$check_workflow/" \
      -e "s/__CHECK_RUNBOOKS__/$check_runbooks/" \
      "$tmp" 2>/dev/null; then
    sed \
      -e "s/__CHECK_PATCH__/$check_patchsh/" \
      -e "s/__PERM_PATCH__/$check_patchsh/" \
      -e "s/__CHECK_MKDOCS__/$check_mkdocs/" \
      -e "s/__CHECK_DOCS__/$check_docs/" \
      -e "s/__CHECK_WORKFLOW__/$check_workflow/" \
      -e "s/__CHECK_RUNBOOKS__/$check_runbooks/" \
      "$tmp" > "$tmp.sed" && mv "$tmp.sed" "$tmp"
  fi
  echo "Repo map checks: patch.sh=$check_patchsh mkdocs.yml=$check_mkdocs docs/=$check_docs pages.yml=$check_workflow runbooks=$check_runbooks"

  # Replace or append block in dest
  if grep -q '^<!-- BEGIN: REPO_MAP' "$dest" 2>/dev/null; then
    # macOS/BSD sed -i
    sed -i '' -e '/<!-- BEGIN: REPO_MAP/,/<!-- END: REPO_MAP/d' "$dest" 2>/dev/null || true
  fi
  echo "AI Context: updating auto-generated Repository Map in $dest"
  # Append fresh block
  cat "$tmp" >> "$dest"
  rm -f "$tmp"
  echo "AI Context: repo map updated."
}

#
# --- Rewrite legacy links in markdown files -----------------------------------
# Rewrite old links in markdown files to new numbered filenames (BSD/GNU sed-safe)
rewrite_legacy_links() {
  # Map of old -> new paths used in file renames above
  link_maps=(
    "05-Proxmox-Cluster-Setup.md|06-Proxmox-Cluster-Setup.md"
    "06-CI-CD-for-Terraform.md|07-CI-CD-for-Terraform.md"
    "07-Image-Factory.md|08-Image-Factory.md"
    "08-Core-Infra-VMs.md|09-Core-Infra-VMs.md"
    "09-Docker-Swarm-Cluster.md|10-Docker-Swarm-Cluster.md"
    "10-Traefik-Authentik-Public-DNS-VPN.md|11-Traefik-Authentik-Public-DNS-VPN.md"
    "11-Integration-Pass-1.md|12-Integration-Pass-1.md"
    "12-Migrations-and-Refactor.md|13-Migrations-and-Refactor.md"
    "13-Observability-and-Alerting.md|14-Observability-and-Alerting.md"
    "14-Ops-Readiness.md|15-Ops-Readiness.md"
    "15-Local-DNS.md|16-Local-DNS.md"
    "16-DMZ-and-Routing.md|17-DMZ-and-Routing.md"
    "17-Public-Status-Page-and-Alerting.md|18-Public-Status-Page-and-Alerting.md"
    "18-Workloads.md|19-Workloads.md"
    "19-Graduation.md|20-Graduation.md"
    "04-NAS-Setup.md|05-NAS-Setup.md"
  )
  # Target markdown files
  files=$(ls index.md 2>/dev/null; ls docs/*.md 2>/dev/null)
  for md in $files; do
    [ -f "$md" ] || continue
    for m in "${link_maps[@]}"; do
      old="${m%%|*}"; new="${m##*|}"
      # Replace occurrences inside link targets and bare references
      if ! sed -i '' -e "s|(${old})|(${new})|g" -e "s|'${old}'|'${new}'|g" -e "s|\"${old}\"|\"${new}\"|g" "$md" 2>/dev/null; then
        sed -e "s|(${old})|(${new})|g" -e "s|'${old}'|'${new}'|g" -e "s|\"${old}\"|\"${new}\"|g" "$md" > "$md.tmp" && mv "$md.tmp" "$md"
      fi
    done
  done
  echo "Rewrote legacy links in markdown files."
}

# Rebuild mkdocs.yml nav and refresh repo map
rebuild_nav() {
  if [ -f mkdocs.yml ]; then
    : <<'DISABLED_FAVICONS'
    # Ensure favicon and touch icons exist and are wired
    _PNG_1x1_B64="iVBORw0KGgoAAAANSUhEUgAAAAEAAAABCAQAAAC1HAwCAAAAC0lEQVR4nGNgYAAAAAMAASsJTYQAAAAASUVORK5CYII="
    mkdir -p docs/assets
    if [ ! -f docs/assets/favicon.png ]; then
      { printf "%s" "$_PNG_1x1_B64" | base64 -d 2>/dev/null || printf "%s" "$_PNG_1x1_B64" | base64 -D 2>/dev/null; } > docs/assets/favicon.png || true
      echo "Seeded docs/assets/favicon.png"
    fi
    if [ ! -f docs/assets/apple-touch-icon.png ]; then
      { printf "%s" "$_PNG_1x1_B64" | base64 -d 2>/dev/null || printf "%s" "$_PNG_1x1_B64" | base64 -D 2>/dev/null; } > docs/assets/apple-touch-icon.png || true
      echo "Seeded docs/assets/apple-touch-icon.png"
    fi
    if [ ! -f docs/assets/favicon.ico ]; then
      cp -f docs/assets/favicon.png docs/assets/favicon.ico 2>/dev/null || cat docs/assets/favicon.png > docs/assets/favicon.ico
      echo "Seeded docs/assets/favicon.ico"
    fi
    if ! grep -q '^site_favicon:' mkdocs.yml; then
      printf '\nsite_favicon: assets/favicon.png\n' >> mkdocs.yml
      echo "Set site_favicon: assets/favicon.png"
    fi
DISABLED_FAVICONS

    # 1) Build Runbooks block from docs/runbooks/*.md
    tmp_rb=$(mktemp)
    {
      printf "  - Runbooks:\n"
      LC_ALL=C ls -1 docs/runbooks/*.md 2>/dev/null | LC_ALL=C sort | while read -r f; do
        [ -e "$f" ] || continue
        base=$(basename "$f"); slug=${base%.md}
        title=$(printf "%s" "$slug" | tr '_-' ' ' | awk '{ $1=$1; for(i=1;i<=NF;i++){ w=$i; $i=toupper(substr(w,1,1)) tolower(substr(w,2)) } print }')
        printf "    - %s: runbooks/%s\n" "$title" "$base"
      done
    } > "$tmp_rb"
    rb_count=$(($(wc -l < "$tmp_rb") - 1))
    echo "Nav: discovered $rb_count runbook(s)"

    # 2) Extract mkdocs.yml without the existing nav block
    tmp_base=$(mktemp)
    awk '
      BEGIN{inblock=0}
      /^nav:/ {inblock=1; next}
      inblock==1 && /^[^[:space:]]/ {inblock=0}
      inblock==0 {print}
    ' mkdocs.yml > "$tmp_base"

    # 3) Write a fresh nav block (stable order)
    tmp_nav=$(mktemp)
    {
      echo "nav:"
      echo "  - Home: index.md"
      for entry in "${chapters[@]}"; do
        stem="${entry%%|*}"; rest="${entry#*|}"; title="${rest%%|*}"
        printf "  - %s: %s\n" "$title" "${stem}.md"
      done
      cat <<'YAML_EOF'
  - Reference:
    - AI Context: ai-context.md
    - Glossary: glossary.md
YAML_EOF
    } > "$tmp_nav"

    # 4) Append dynamic Runbooks block if any entries exist
    if [ $(wc -l < "$tmp_rb") -gt 1 ]; then
      cat "$tmp_rb" >> "$tmp_nav"
    fi

    # 5) Combine base config + rebuilt nav
    cat "$tmp_base" "$tmp_nav" > mkdocs.yml.tmp && mv mkdocs.yml.tmp mkdocs.yml
    echo "Nav: mkdocs.yml rebuilt; runbooks injected ($rb_count)."

    # Ensure core reference files exist and refresh repo map
    ensure_file "docs/glossary.md" "Glossary (DAT — Define Acronyms & Terms)"
    ensure_file "docs/ai-context.md" "AI Context (Decisions & Repo Map)"
    upsert_repo_map
  fi
}

#
# --- Chapter filenames (numbered) -------------------------------------------
# Format: "FileStem|Nav Title|Icon"
# File path becomes docs/<NN-FileStem>.md
chapters=(
  "01-Hardware|Hardware|material/memory"
  "02-Workstation-Setup|Workstation Setup|material/laptop"
  "03-Cloud-Accounts-and-Foundations|Cloud Accounts & Foundations|material/cloud"
  "04-Network-Setup|Network Setup & Terraform Imports|material/lan"
  "05-NAS-Setup|NAS Setup|material/harddisk"
  "06-Proxmox-Cluster-Setup|Proxmox Cluster Setup|material/server"
  "07-CI-CD-for-Terraform|CI/CD for Terraform|material/git"
  "08-Image-Factory|Image Factory|material/image"
  "09-Core-Infra-VMs|Core Infra VMs|material/server"
  "10-Docker-Swarm-Cluster|Docker Swarm Cluster|material/docker"
  "11-Traefik-Authentik-Public-DNS-VPN|Traefik + Authentik + Public DNS + VPN|material/shield-lock"
  "12-Integration-Pass-1|Integration Pass|material/link"
  "13-Migrations-and-Refactor|Migrations & Refactor|material/swap-horizontal"
  "14-Observability-and-Alerting|Observability + Alerting|material/chart-line"
  "15-Ops-Readiness|Ops Readiness|material/clipboard-check"
  "16-Local-DNS|Local DNS|material/dns"
  "17-DMZ-and-Routing|DMZ & Routing|material/lan"
  "18-Public-Status-Page-and-Alerting|Public Status Page + Alerting|material/alert"
  "19-Workloads|Workloads|material/rocket-launch"
  "20-Graduation|Graduation|material/flag-checkered"
  "21-Lab-and-Service-Ideas|Lab & Service Ideas|material/lightbulb-on"
)

# CLI: split-mode helpers
if [ $# -gt 0 ]; then
  case "$1" in
    --help|-h)
      usage; exit 0 ;;
    --ai)
      shift; append_ai_decision "$*"; exit 0 ;;
    --verify-map)
      upsert_repo_map; exit 0 ;;
    --verify)
      echo "[DEPRECATED] Use --verify-map instead of --verify." >&2
      upsert_repo_map
      exit 0 ;;
    --nav)
      RUN_NAV_ONLY=1
      ;;
    --full)
      # fall through to normal full run
      ;;
    *)
      echo "Unknown option: $1" >&2; usage; exit 1 ;;
  esac
fi
# --- end AI Context helpers ---------------------------------------------------
echo "patch.sh: starting (args: $*) on branch $(git rev-parse --abbrev-ref HEAD 2>/dev/null || echo 'n/a')"

# Helper: ensure a chapter file exists with a minimal scaffold
ensure_chapter() {
  local file="$1"      # docs/NN-Stem.md
  local title="$2"     # Nav Title
  local icon="$3"
  CREATED_LAST=0
  if [ ! -f "$file" ]; then
    mkdir -p "$(dirname "$file")"
    cat > "$file" <<EOF
---
icon: $icon
---
# $title

## Overview
_TBD: brief purpose of this chapter._

## Outcomes
- _TBD_

## Entry Checks
- _TBD_

## Labs
- _TBD_

## Validation
- [ ] _TBD_

## Exit Criteria
- [ ] _TBD_

## Next
_TBD_
EOF
    CREATED_LAST=1
    echo "Created chapter: $file"
  fi
}

# Ensure an icon key exists in YAML front matter; add or replace as needed
ensure_icon_front_matter() {
  local file="$1"
  local icon="$2"
  if [ ! -f "$file" ]; then
    return 0
  fi
  # If file starts with front matter
  if head -n1 "$file" | grep -q '^---$'; then
    # Replace existing icon line or insert after opening ---
    if grep -q '^icon:' "$file"; then
      # BSD/GNU compatible edit
      if ! sed -i '' -E "1,/^---$/ s|^icon:.*$|icon: $icon|" "$file" 2>/dev/null; then
        sed -E "1,/^---$/ s|^icon:.*$|icon: $icon|" "$file" > "$file.tmp" && mv "$file.tmp" "$file"
      fi
    else
      # Insert icon line after the first --- line
      awk 'NR==1{print; print "icon: '"$icon"'"; next}1' "$file" > "$file.tmp" && mv "$file.tmp" "$file"
    fi
  else
    # No front matter; prepend it
    cat > "$file.tmp" <<EOF
---
icon: $icon
---
EOF
    cat "$file" >> "$file.tmp"
    mv "$file.tmp" "$file"
  fi
}

# 17) Normalize chapter filenames and icons
# Legacy -> numbered filename migration map (if old exists and new missing, git mv)
# Pairs: "old_path|new_path"

for map in \
  "docs/hardware.md|docs/01-Hardware.md" \
  "docs/workstation-setup.md|docs/02-Workstation-Setup.md" \
  "docs/cloud-control-plane-setup.md|docs/03-Cloud-Accounts-and-Foundations.md" \
  "docs/phase3-storage-backups.md|docs/04-NAS-Setup.md" \
  "docs/control-plane.md|docs/05-Proxmox-Cluster-Setup.md" \
  "docs/phase4-observability.md|docs/13-Observability-and-Alerting.md" \
  "docs/migration.md|docs/12-Migrations-and-Refactor.md" \
  "docs/phase6-first-workloads.md|docs/18-Workloads.md" \
  "docs/release.md|docs/19-Graduation.md" \
  "docs/04-NAS-Setup.md|docs/05-NAS-Setup.md" \
  "docs/05-Proxmox-Cluster-Setup.md|docs/06-Proxmox-Cluster-Setup.md" \
  "docs/06-CI-CD-for-Terraform.md|docs/07-CI-CD-for-Terraform.md" \
  "docs/07-Image-Factory.md|docs/08-Image-Factory.md" \
  "docs/08-Core-Infra-VMs.md|docs/09-Core-Infra-VMs.md" \
  "docs/09-Docker-Swarm-Cluster.md|docs/10-Docker-Swarm-Cluster.md" \
  "docs/10-Traefik-Authentik-Public-DNS-VPN.md|docs/11-Traefik-Authentik-Public-DNS-VPN.md" \
  "docs/11-Integration-Pass-1.md|docs/12-Integration-Pass-1.md" \
  "docs/12-Migrations-and-Refactor.md|docs/13-Migrations-and-Refactor.md" \
  "docs/13-Observability-and-Alerting.md|docs/14-Observability-and-Alerting.md" \
  "docs/14-Ops-Readiness.md|docs/15-Ops-Readiness.md" \
  "docs/15-Local-DNS.md|docs/16-Local-DNS.md" \
  "docs/16-DMZ-and-Routing.md|docs/17-DMZ-and-Routing.md" \
  "docs/17-Public-Status-Page-and-Alerting.md|docs/18-Public-Status-Page-and-Alerting.md" \
  "docs/18-Workloads.md|docs/19-Workloads.md" \
  "docs/19-Graduation.md|docs/20-Graduation.md" \
; do
  old="${map%%|*}"; new="${map##*|}"
  if [ -f "$old" ] && [ ! -f "$new" ]; then
    git mv "$old" "$new"
    echo "Renamed: $old -> $new"
  fi
done

# Remove deprecated, unreferenced legacy chapter files if present
for legacy in docs/phase1-foundations.md docs/phase2-networking.md docs/phase5-security.md; do
  if [ -f "$legacy" ]; then
    git rm -f "$legacy" 2>/dev/null || rm -f "$legacy"
    echo "Removed legacy file: $legacy"
  fi
done


# Ensure all chapter files exist and have front matter with icons
for entry in "${chapters[@]}"; do
  stem="${entry%%|*}"; rest="${entry#*|}"
  title="${rest%%|*}"; icon="${rest##*|}"
  file="docs/${stem}.md"
  ensure_chapter "$file" "$title" "$icon"
  # enforce icon in front matter
  if [ "${CREATED_LAST:-0}" = "1" ]; then
    ensure_icon_front_matter "$file" "$icon"
  fi
done

# Seed Chapter 04 with a structured network outline
net_file="docs/04-Network-Setup.md"
if [ ! -f "$net_file" ] || grep -q '_TBD_' "$net_file"; then
  mkdir -p "$(dirname "$net_file")"
  cat > "$net_file" <<'EOF'
---
icon: material/lan
---
# Network Setup & Terraform Imports

## Overview
Define LAN/VLAN plan, assign CIDRs, configure router/switch, then import discovered resources into Terraform.

## Outcomes
- VLANs and CIDRs documented and provisioned.
- Router/firewall interfaces and DHCP scopes configured.
- Terraform state updated via `terraform import` for existing network objects.

## Entry Checks
- Router/firewall reachable via UI and SSH.
- Admin creds and backup exported.
- Terraform CLI installed and working.

## Labs
1. **Design the addressing plan**
   - Choose RFC1918 blocks and per‑VLAN CIDRs.
   - Reserve infra ranges for gateways, DHCP, DNS, and static hosts.
2. **Define VLANs and tagging**
   - Map names → IDs (e.g., `10-MGMT`, `20-SERVERS`, `30-IOT`, `40-GUEST`).
   - Document trunk and access ports on the switch.
3. **Configure router/firewall**
   - Create VLAN interfaces and gateways.
   - Enable DHCP per VLAN and set DNS.
   - Add basic inter‑VLAN rules and block guest→LAN.
4. **Export and import to Terraform**
   - Initialize provider for your platform.
   - Use `terraform import` to capture existing VLANs, interfaces, DHCP, and rules.
   - Run `terraform plan` to verify drift is zero.

## Validation
- [ ] Hosts on each VLAN receive DHCP and reach gateway.
- [ ] Expected inter‑VLAN access allowed; blocked paths denied.
- [ ] `terraform plan` shows no changes after import.

## Exit Criteria
- [ ] CIDR/VLAN matrix committed to the repo.
- [ ] Router/switch configs backed up.
- [ ] Terraform state contains imported network resources.

## Next
Proceed to NAS setup and Proxmox cluster.
EOF
  echo "Seeded $net_file"
fi

# Seed Chapter 21 with curated ideas (no torrent stack)
ideas_file="docs/21-Lab-and-Service-Ideas.md"
if [ ! -f "$ideas_file" ] || grep -q '_TBD_' "$ideas_file"; then
  mkdir -p "$(dirname "$ideas_file")"
  cat > "$ideas_file" <<'EOF'
---
icon: material/lightbulb-on
---
# Lab & Service Ideas

Curated backlog for future labs and services. Prioritize as needed.

## Media and Home Services
- **Full automated Plex service (Usenet-only)**: Plex + Sonarr/Radarr/Lidarr + NZBGet/SABnzbd + Recyclarr. Exclude torrent clients to avoid ISP issues.
- **Image Management & Google Takeout Cleanup**: Immich or PhotoPrism, with EXIF normalization and deduplication pipeline.
- **DVD/Blu‑ray conversion for Plex**: MakeMKV + HandBrake + (optional) Tdarr for transcode automation.

## Gaming
- **Local Game Servers**: Minecraft, Valheim, Palworld, Factorio. Containerized with Portainer or Swarm stacks.

## AI and Tools
- **Private Local AI service**: Ollama + Open WebUI (text) and ComfyUI/InvokeAI (images). GPU optional.
- **Ticket system**: GLPI or Zammad for helpdesk plus inventory.
- **Local AI Doctor**: OpenHealthForAll – https://github.com/OpenHealthForAll/open-health

## Notes
- Prefer bind mounts on your `docker-lun` for persistence.
- Centralize secrets in Vault once deployed.
- Use Traefik labels for uniform ingress naming.
EOF
  echo "Seeded $ideas_file"
fi


# 17b) Rewrite links after renames
rewrite_legacy_links

# 18) Rebuild nav deterministically and inject dynamic Runbooks
rebuild_nav


echo "patch.sh: complete"
echo "Reminder: In a new AI chat, share docs/ai-context.md to restore full repo context."

# Final report: show concise git status so changes are not lost
if command -v git >/dev/null 2>&1; then
  echo "----- git status (short) -----"
  git status -sb 2>/dev/null || git status || true
fi
