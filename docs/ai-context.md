---
icon: material/robot-happy
---
# AI Context (Decisions & Repo Map)

This page holds durable context for collaborating with AI on this repo. Entries are **appended** and never auto-deleted.

## Decision Log

No pending decisions. This section is cleared on each repo update. New decisions are appended here until the next run.




## AI Prompt for New Chat

The following prompt is recommended for starting a new chat with the AI on this repository. It ensures that all changes to `docs/ai-context.md` are tracked and updated using the correct process, and that AI sessions follow best practices for reliability and reproducibility.

```text
When collaborating on this repository:
- Output the commands to update `docs/ai-context.md` using `./patch.sh` whenever changes are made to this file.
- Start each new session by creating a new branch.
- Only add commits and open pull requests for changes that have been tested and are known to work.
- Periodically check the Git status to ensure that no changes are lost.
```

## Patch Script Command Template

This is a ready-to-run sequence the AI should output when updating this file.

```bash
# Create a working branch
git checkout -b docs/ai-context-refresh-$(date +%Y%m%d-%H%M)

# Refresh Decision Log and Repo Map via patch script
./patch.sh --ai "Decision: Refresh AI Context and Repo Map"

# Verify repo map and icons after changes
./patch.sh --verify

# Stage and commit only tested, working changes
git add docs/ai-context.md mkdocs.yml .github/workflows/pages.yml docs/ || true
git commit -m "docs: refresh AI Context and Repo Map"

# Push and open a pull request against main
git push -u origin $(git branch --show-current)
gh pr create -B main -t "docs: refresh AI Context and Repo Map" -b "Automated update using patch.sh --verify"
```

Notes:
- Run from the repo root where `patch.sh` lives.
- `gh` GitHub CLI is optional; if unavailable, open the PR manually.
- Run `git status` before and after `./patch.sh` to avoid losing untracked changes.

## AI Prompt Helper

Use this prompt to refresh the AI Context file:

```
Review the repo. Summarize new decisions since the last run. Append them under '## Decision Log'. Then regenerate the Repository Map section. Clear out older decision entries to keep the file clean.
```
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
| `patch.sh` | Repo maintainer script | ✅ | executable: ✅ |
| `mkdocs.yml` | MkDocs site config | ✅ | readable |
| `docs/` | Documentation root | ✅ | readable |
| `.github/workflows/pages.yml` | Pages CI workflow | ✅ | readable |
| `docs/runbooks/*.md` | Runbooks content | ✅ | readable |

### Quick Tests
- Serve docs locally: `source .venv/bin/activate && mkdocs serve -a 0.0.0.0:8000`
- Build static site: `mkdocs build`
- Verify theme dark default + icons load on home page.

<!-- END: REPO_MAP -->
