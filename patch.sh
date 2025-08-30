#!/usr/bin/env bash
set -u
# NOTE: Experimental mutators (mkdocs.yml tweaks, legacy link rewrites) are temporarily disabled
# to prevent duplication and churn. We will re‑enable after review.
#
# --- AI Context helpers -------------------------------------------------------
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
  - `docs/04-NAS-Setup.md` — Storage and backup services.
  - `docs/05-Proxmox-Cluster-Setup.md` — Proxmox cluster deployment.
  - `docs/06-CI-CD-for-Terraform.md` — CI/CD pipelines for Terraform workflows.
  - `docs/07-Image-Factory.md` — Image building and automation.
  - `docs/08-Core-Infra-VMs.md` — Core VM deployments (Jump Box, PBS, etc).
  - `docs/09-Docker-Swarm-Cluster.md` — Docker Swarm cluster setup.
  - `docs/10-Traefik-Authentik-Public-DNS-VPN.md` — Reverse proxy, SSO, public DNS, VPN.
  - `docs/11-Integration-Pass-1.md` — First integration pass (import resources to TF/Vault/Consul).
  - `docs/12-Migrations-and-Refactor.md` — State migrations and refactor.
  - `docs/13-Observability-and-Alerting.md` — Monitoring, logging, and alerting.
  - `docs/14-Ops-Readiness.md` — Ops readiness, DR, runbooks, SLOs.
  - `docs/15-Local-DNS.md` — Local DNS (Pi-hole, CoreDNS, Bind).
  - `docs/16-DMZ-and-Routing.md` — DMZ setup and routing policies.
  - `docs/17-Public-Status-Page-and-Alerting.md` — Public status page and alerting.
  - `docs/18-Workloads.md` — Workloads (Plex, Game Servers, Family Photos).
  - `docs/19-Graduation.md` — Graduation and wrap-up.
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

# CLI: allow --ai "text" and --verify to be invoked directly
if [ $# -gt 0 ]; then
  case "$1" in
    --ai)
      shift
      append_ai_decision "$*"
      ;;
    --verify)
      shift
      upsert_repo_map
      ;;
  esac
fi
# --- end AI Context helpers ---------------------------------------------------
echo "patch.sh: starting (args: $*) on branch $(git rev-parse --abbrev-ref HEAD 2>/dev/null || echo 'n/a')"

# --- Chapter filenames (numbered) -------------------------------------------
# Format: "FileStem|Nav Title|Icon"
# File path becomes docs/<NN-FileStem>.md
chapters=(
  "01-Hardware|Hardware|material/memory"
  "02-Workstation-Setup|Workstation Setup|material/laptop"
  "03-Cloud-Accounts-and-Foundations|Cloud Accounts & Foundations|material/cloud"
  "04-NAS-Setup|NAS Setup|material/harddisk"
  "05-Proxmox-Cluster-Setup|Proxmox Cluster Setup|material/server"
  "06-CI-CD-for-Terraform|CI/CD for Terraform|material/git"
  "07-Image-Factory|Image Factory|material/image"
  "08-Core-Infra-VMs|Core Infra VMs|material/server"
  "09-Docker-Swarm-Cluster|Docker Swarm Cluster|material/docker"
  "10-Traefik-Authentik-Public-DNS-VPN|Traefik + Authentik + Public DNS + VPN|material/shield-lock"
  "11-Integration-Pass-1|Integration Pass|material/link"
  "12-Migrations-and-Refactor|Migrations & Refactor|material/swap-horizontal"
  "13-Observability-and-Alerting|Observability + Alerting|material/chart-line"
  "14-Ops-Readiness|Ops Readiness|material/clipboard-check"
  "15-Local-DNS|Local DNS|material/dns"
  "16-DMZ-and-Routing|DMZ & Routing|material/lan"
  "17-Public-Status-Page-and-Alerting|Public Status Page + Alerting|material/alert"
  "18-Workloads|Workloads|material/rocket-launch"
  "19-Graduation|Graduation|material/flag-checkered"
)

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
  "docs/release.md|docs/19-Graduation.md"; do
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

: <<'DISABLED_REWRITE'
# 17b) Rewrite old links in docs/*.md to new numbered filenames
rewrite_legacy_links=(
  "workstation-setup.md|02-Workstation-Setup.md"
  "cloud-control-plane-setup.md|03-Cloud-Accounts-and-Foundations.md"
  "hardware.md|01-Hardware.md"
  "phase3-storage-backups.md|04-NAS-Setup.md"
  "control-plane.md|05-Proxmox-Cluster-Setup.md"
  "migration.md|12-Migrations-and-Refactor.md"
  "phase4-observability.md|13-Observability-and-Alerting.md"
  "phase6-first-workloads.md|18-Workloads.md"
  "release.md|19-Graduation.md"
)
for md in docs/*.md; do
  [ -f "$md" ] || continue
  for m in "${link_maps[@]}"; do
    old="${m%%|*}"; new="${m##*|}"
    # Replace occurrences inside () link targets and bare references
    if ! sed -i '' -e "s|(${old})|(${new})|g" -e "s|'${old}'|'${new}'|g" -e "s|\"${old}\"|\"${new}\"|g" "$md" 2>/dev/null; then
      sed -e "s|(${old})|(${new})|g" -e "s|'${old}'|'${new}'|g" -e "s|\"${old}\"|\"${new}\"|g" "$md" > "$md.tmp" && mv "$md.tmp" "$md"
    fi
  done
done
DISABLED_REWRITE

# 18) Rebuild nav deterministically and inject dynamic Runbooks
if [ -f mkdocs.yml ]; then
  : <<'DISABLED_FAVICONS'
  # Ensure favicon and touch icons exist and are wired
  # 1x1 transparent PNG (base64)
  _PNG_1x1_B64="iVBORw0KGgoAAAANSUhEUgAAAAEAAAABCAQAAAC1HAwCAAAAC0lEQVR4nGNgYAAAAAMAASsJTYQAAAAASUVORK5CYII="

  # Create assets dir
  mkdir -p docs/assets

  # Write assets if missing
  if [ ! -f docs/assets/favicon.png ]; then
    { printf "%s" "$_PNG_1x1_B64" | base64 -d 2>/dev/null || printf "%s" "$_PNG_1x1_B64" | base64 -D 2>/dev/null; } > docs/assets/favicon.png || true
    echo "Seeded docs/assets/favicon.png"
  fi
  if [ ! -f docs/assets/apple-touch-icon.png ]; then
    { printf "%s" "$_PNG_1x1_B64" | base64 -d 2>/dev/null || printf "%s" "$_PNG_1x1_B64" | base64 -D 2>/dev/null; } > docs/assets/apple-touch-icon.png || true
    echo "Seeded docs/assets/apple-touch-icon.png"
  fi
  if [ ! -f docs/assets/favicon.ico ]; then
    # Use the same PNG content for .ico to satisfy browser requests; many browsers accept PNG here
    cp -f docs/assets/favicon.png docs/assets/favicon.ico 2>/dev/null || cat docs/assets/favicon.png > docs/assets/favicon.ico
    echo "Seeded docs/assets/favicon.ico"
  fi

  # Wire site_favicon in mkdocs.yml if missing
  if ! grep -q '^site_favicon:' mkdocs.yml; then
    printf '\nsite_favicon: assets/favicon.png\n' >> mkdocs.yml
    echo "Set site_favicon: assets/favicon.png"
  fi
DISABLED_FAVICONS

  # 1) Build Runbooks block from docs/runbooks/*.md
  tmp_rb=$(mktemp)
  {
    printf "  - Runbooks:\n"
    # Ensure consistent collation and sorted order
    LC_ALL=C ls -1 docs/runbooks/*.md 2>/dev/null | LC_ALL=C sort | while read -r f; do
      [ -e "$f" ] || continue
      base=$(basename "$f")
      slug=${base%.md}
      # Normalize separators to single spaces, trim, and title-case (ASCII)
      title=$(printf "%s" "$slug" \
        | tr '_-' ' ' \
        | awk '{
            $1=$1;                             # trim leading spaces
            for(i=1;i<=NF;i++){
              w=$i;
              # lowercase rest of word, uppercase first char
              $i=toupper(substr(w,1,1)) tolower(substr(w,2));
            }
            print
          }')
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
    # Emit numbered chapters
    for entry in "${chapters[@]}"; do
      stem="${entry%%|*}"; rest="${entry#*|}"; title="${rest%%|*}"
      printf "  - %s: %s\n" "$title" "${stem}.md"
    done
    # Reference group
    cat <<'YAML_EOF'
  - Reference:
    - AI Context: ai-context.md
    - Glossary: glossary.md
YAML_EOF
  } > "$tmp_nav"

  # 4) Append dynamic Runbooks block if any entries exist (more than header line)
  if [ $(wc -l < "$tmp_rb") -gt 1 ]; then
    cat "$tmp_rb" >> "$tmp_nav"
  fi

  # 5) Combine base config + rebuilt nav
  cat "$tmp_base" "$tmp_nav" > mkdocs.yml.tmp && mv mkdocs.yml.tmp mkdocs.yml
  echo "Nav: mkdocs.yml rebuilt; runbooks injected ($rb_count)."

  # 5b) Ensure docs/glossary.md and docs/ai-context.md exist
  ensure_file "docs/glossary.md" "Glossary (DAT — Define Acronyms & Terms)"
  ensure_file "docs/ai-context.md" "AI Context (Decisions & Repo Map)"
  # Update the auto-generated repo map block
  upsert_repo_map

  : <<'DISABLED_SEARCH'
  # 6) Ensure search plugin present
  if ! awk '/^plugins:/{f=1} f&&/^  - search$/{found=1} END{exit(found?0:1)}' mkdocs.yml; then
    if grep -q '^plugins:' mkdocs.yml; then
      awk '
        /^plugins:/ {print; print "  - search"; next}
        {print}
      ' mkdocs.yml > mkdocs.yml.tmp && mv mkdocs.yml.tmp mkdocs.yml
    else
      printf '\nplugins:\n  - search\n' >> mkdocs.yml
    fi
    echo "Enabled plugins: search"
    :
  fi
  # Ensure mkdocs hooks configuration includes hooks.py
  if ! awk '/^hooks:/{f=1} f&&/^- hooks\.py$/{found=1} END{exit(found?0:1)}' mkdocs.yml; then
    if grep -q '^hooks:' mkdocs.yml; then
      awk '
        /^hooks:/ {print; print "  - hooks.py"; next}
        {print}
      ' mkdocs.yml > mkdocs.yml.tmp && mv mkdocs.yml.tmp mkdocs.yml
    else
      printf '\nhooks:\n  - hooks.py\n' >> mkdocs.yml
    fi
    echo "Enabled hooks: hooks.py"
  fi
DISABLED_SEARCH
  : <<'DISABLED_HOOKS'
  # Ensure mkdocs hooks configuration includes hooks.py
  if ! awk '/^hooks:/{f=1} f&&/^- hooks\.py$/{found=1} END{exit(found?0:1)}' mkdocs.yml; then
    if grep -q '^hooks:' mkdocs.yml; then
      awk '
        /^hooks:/ {print; print "  - hooks.py"; next}
        {print}
      ' mkdocs.yml > mkdocs.yml.tmp && mv mkdocs.yml.tmp mkdocs.yml
    else
      printf '\nhooks:\n  - hooks.py\n' >> mkdocs.yml
    fi
    echo "Enabled hooks: hooks.py"
  fi
DISABLED_HOOKS

: <<'DISABLED_MD_EXT'
  # Ensure markdown_extensions includes abbr and pymdownx.snippets with check_paths: true and base_path: [docs]
  # Find if markdown_extensions exists
  if grep -q '^markdown_extensions:' mkdocs.yml; then
    # Check if abbr is present
    if ! grep -q '^\s*-\s*abbr' mkdocs.yml; then
      # Insert abbr under markdown_extensions
      sed -i '' '/^markdown_extensions:/a\
  - abbr
' mkdocs.yml
    fi
    # Check if pymdownx.snippets is present
    if ! grep -q '^\s*-\s*pymdownx\.snippets' mkdocs.yml; then
      # Insert pymdownx.snippets with check_paths: true and base_path: [docs] under markdown_extensions
      # Find line number of markdown_extensions
      md_ext_line=$(grep -n '^markdown_extensions:' mkdocs.yml | cut -d: -f1)
      # Insert after markdown_extensions line
      sed -i '' "$((md_ext_line))a\\
  - pymdownx.snippets:\\
      check_paths: true\\
      base_path:\\
        - docs
" mkdocs.yml
    else
      # pymdownx.snippets present, check for check_paths: true
      # If not present, add it
      if ! grep -A1 '^\s*-\s*pymdownx\.snippets' mkdocs.yml | grep -q 'check_paths:\s*true'; then
        # Find line number of pymdownx.snippets
        pms_line=$(grep -n '^\s*-\s*pymdownx\.snippets' mkdocs.yml | cut -d: -f1)
        # Insert check_paths: true after that line
        sed -i '' "$((pms_line))a\\
    check_paths: true
" mkdocs.yml
      fi
      # Ensure base_path: docs is set
      if ! awk 'f&&/^\s*base_path:/ {bp=1} /^\s*-\s*pymdownx\.snippets/ {f=1} f&&/^\s*-\s*[A-Za-z0-9_.-]+/ {f=0} END{exit(bp?0:1)}' mkdocs.yml; then
        # Insert base_path under pymdownx.snippets
        pms_line=$(grep -n '^\s*-\s*pymdownx\.snippets' mkdocs.yml | head -1 | cut -d: -f1)
        sed -i '' "$((pms_line))a\\
      base_path:\\
        - docs
" mkdocs.yml 2>/dev/null || {
          awk -v n="$pms_line" 'NR==n{print; print "      base_path:\n        - docs"; next}1' mkdocs.yml > mkdocs.yml.tmp && mv mkdocs.yml.tmp mkdocs.yml
        }
      fi
    fi
  else
    # markdown_extensions not present, add it at end with abbr and pymdownx.snippets
    cat >> mkdocs.yml <<EOF

markdown_extensions:
  - abbr
  - pymdownx.snippets:
      check_paths: true
      base_path:
        - docs
EOF
  fi

  # Ensure shared abbreviations snippet exists
  if [ ! -f docs/includes/abbreviations.md ]; then
    mkdir -p docs/includes
    cat > docs/includes/abbreviations.md <<'ABBR'
<!-- Shared abbreviations for hover tooltips across the site -->
*[DAT]: Define Acronyms & Terms, the glossary itself
ABBR
    echo "Seeded docs/includes/abbreviations.md (add full definitions later)."
  fi

  # Always refresh the repo map (non-destructive)
  upsert_repo_map
DISABLED_MD_EXT
fi

echo "patch.sh: complete"
echo "Reminder: In a new AI chat, share docs/ai-context.md to restore full repo context."

# Final report: show concise git status so changes are not lost
if command -v git >/dev/null 2>&1; then
  echo "----- git status (short) -----"
  git status -sb 2>/dev/null || git status || true
fi
