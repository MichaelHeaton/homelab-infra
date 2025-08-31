---
icon: material/robot-happy
---
# AI Context (Decisions & Repo Map)

This page holds durable context for collaborating with AI on this repo. Entries are **appended** and never auto-deleted.

## Decision Log

No pending decisions. This section is cleared on each repo update. New decisions are appended here until the next run.

- The Glossary (`docs/glossary.md`) should be maintained in strict alphabetical order.

### Standing Rules

- **File Focus:** Respect the declared File Focus before editing. Do not touch other files unless requested.
- **Lab Order by Dependency:** Order labs so dependencies come first. Example: Consul before Vault.
- **Abbreviations:** Centralize in `docs/includes/abbreviations.md`. Each page should include them at the top using
  `--8<-- "includes/abbreviations.md"`.
- **Glossary Hygiene:** When a new tool or protocol appears, add it to `docs/glossary.md` and keep terms strictly alphabetical.
- **Scope Control:** Only document shares or configs we plan to keep. Avoid listing temporary paths.
- **Patch Script & Git Discipline:** Use `./patch.sh` to refresh maps/icons. Start work on a new branch. Commit only tested, working changes. Run `git status` before and after `./patch.sh`.

### Style & Theme Baseline

- **Theme:** MkDocs Material. Dark mode default as configured in `mkdocs.yml`.
- **Headings:** One `#` H1 per page (title). Use `##` for sections, `###` for subsections. No deeper than `####` unless necessary.
- **Tone:** Clear, concise, instructional. American English. Avoid slang.
- **Punctuation:** No em-dashes or ellipses. Prefer commas or parentheses.
- **Lists:** Use `-` for bullets. Indent nested bullets by two spaces.
- **Code Fences:** Always specify a language (`bash`, `yaml`, `hcl`, `json`, `toml`, etc.).
- **Tables:** Compact. Left-align text. Include a header row.
- **Admonitions:** Prefer `!!! note`, `!!! tip`, and `!!! warning` only when they add real value.
- **Links:** Use relative links within the repo. Descriptive link text, no bare URLs.
- **Images/Screenshots:** Place under `docs/assets/`. Name as `section-topic-shortdesc.png`. Reference with relative paths.
- **Abbreviation Tooltips:** Ensure the include snippet line is present near the top of each content page.
- **Checklists:** Use `- [ ]` for tasks and exit criteria. Keep concise.
- **Line Hygiene:** Wrap lines reasonably. No trailing whitespace.

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
Review the repo. Summarize new decisions since the last run. Append them under '## Decision Log'. Then regenerate the Repository Map section with current numbered chapter filenames. Clear out older decision entries to keep the file clean.
```
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
