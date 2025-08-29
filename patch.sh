#!/usr/bin/env bash
set -u
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
  - `docs/workstation-setup.md` — Laptop/desktop tooling installs and verification.
  - `docs/cloud-control-plane-setup.md` — HCP/HCP Terraform/Vault bootstrap.
  - `docs/hardware.md` — Hardware guidance and author’s reference build.
  - `docs/runbooks/` — Operational runbooks for maintenance tasks.
  - `docs/glossary.md` — DAT (Define Acronyms & Terms).
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

# 17) Ensure icons and rename phase files
ensure_icon_front_matter() {
  file="$1"
  icon="$2"
  if [ ! -f "$file" ]; then return; fi
  if head -1 "$file" | grep -q '^---'; then
    # Has front matter
    if awk '/^---/{f=1;next} /^---/{exit} f&&/^icon:/{found=1;exit}' "$file"; then
      # Replace existing icon key
      awk -v ic="$icon" '
        BEGIN{inblock=0}
        NR==1 && /^---/ {inblock=1}
        inblock && /^icon:/ {$0="icon: "ic}
        /^---/ && NR!=1 {inblock=0}
        {print}
      ' "$file" > "$file.tmp" && mv "$file.tmp" "$file"
      echo "Icon ensured: $file -> $icon (replaced)"
    else
      # Insert icon key after opening ---
      awk -v ic="$icon" '
        NR==1 && /^---/ {print; print "icon: "ic; next}
        {print}
      ' "$file" > "$file.tmp" && mv "$file.tmp" "$file"
      echo "Icon ensured: $file -> $icon (inserted)"
    fi
  else
    # No front matter, prepend block
    tmpf=$(mktemp)
    printf -- "---\nicon: %s\n---\n" "$icon" > "$tmpf"
    cat "$file" >> "$tmpf"
    mv "$tmpf" "$file"
    echo "Icon ensured: $file -> $icon (prepended)"
  fi
}
# Main icons for specific files
ensure_icon_front_matter docs/workstation-setup.md material/laptop
ensure_icon_front_matter docs/cloud-control-plane-setup.md material/cloud
ensure_icon_front_matter docs/hardware.md material/memory
ensure_icon_front_matter docs/migration.md material/swap-horizontal
ensure_icon_front_matter docs/control-plane.md material/server
ensure_icon_front_matter docs/release.md material/tag
# Runbooks icons
for f in docs/runbooks/*.md; do
  [ -e "$f" ] || continue
  ensure_icon_front_matter "$f" material/book-open-page-variant
done
# Phase file renames (robust across /bin/sh and bash)
for pair in \
  "phase1.md:phase1-foundations.md" \
  "phase2.md:phase2-networking.md" \
  "phase3.md:phase3-storage-backups.md" \
  "phase4.md:phase4-observability.md" \
  "phase5.md:phase5-security.md" \
  "phase6.md:phase6-first-workloads.md"; do
  src="docs/${pair%%:*}"
  dst="docs/${pair##*:}"
  if [ -f "$src" ] && [ ! -f "$dst" ]; then
    git mv "$src" "$dst"
    echo "Renamed: $src -> $dst"
  fi
done
# Set icons for renamed phase files
ensure_icon_front_matter docs/phase1-foundations.md material/hammer-wrench
ensure_icon_front_matter docs/phase2-networking.md material/lan
ensure_icon_front_matter docs/phase3-storage-backups.md material/harddisk
ensure_icon_front_matter docs/phase4-observability.md material/chart-line
ensure_icon_front_matter docs/phase5-security.md material/shield-lock
ensure_icon_front_matter docs/phase6-first-workloads.md material/rocket-launch

# 18) Rebuild nav deterministically and inject dynamic Runbooks
if [ -f mkdocs.yml ]; then
  # 1) Build Runbooks block from docs/runbooks/*.md
  tmp_rb=$(mktemp)
  printf "  - Runbooks:\n" > "$tmp_rb"
  for f in docs/runbooks/*.md; do
    [ -e "$f" ] || continue
    base=$(basename "$f")
    slug=${base%.md}
    title=$(printf "%s" "$slug" | sed -E 's/[_-]+/ /g; s/\b(.)/\U\1/g')
    printf "    - %s: runbooks/%s\n" "$title" "$base" >> "$tmp_rb"
  done
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
  cat > "$tmp_nav" <<'YAML'
nav:
  - Home: index.md
  - Hardware: hardware.md
  - Workstation Setup: workstation-setup.md
  - Cloud Control Plane Setup: cloud-control-plane-setup.md
  - Foundations: phase1-foundations.md
  - Networking & Access: phase2-networking.md
  - Storage & Backups: phase3-storage-backups.md
  - Observability: phase4-observability.md
  - Security: phase5-security.md
  - First Workloads: phase6-first-workloads.md
  - Migration: migration.md
  - Control Plane: control-plane.md
  - Release: release.md
  - Reference:
      - Glossary: glossary.md
      - AI Context: ai-context.md
YAML
  
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

  # Always refresh the repo map (non-destructive)
  upsert_repo_map
fi

echo "patch.sh: complete"
echo "Reminder: In a new AI chat, share docs/ai-context.md to restore full repo context."

# Final report: show concise git status so changes are not lost
if command -v git >/dev/null 2>&1; then
  echo "----- git status (short) -----"
  git status -sb 2>/dev/null || git status || true
fi
