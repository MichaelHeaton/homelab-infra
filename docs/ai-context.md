---
icon: material/robot-happy
---
# AI Context (Decisions & Repo Map)

!!! info "Quick Overview"
    **What:** Central AI context, decisions, and repo map for collaboration.
    **Why:** Keeps sessions reproducible, consistent, and aligned.
    **Time:** Ongoing; updated whenever structure or rules change.
    **XP:** +20 (like Whose Line, the points are made up but the fun is real).

This is the brain of the campaign—AI collaboration rules, decision logs, and the canonical repo map.

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
- **Gamified Style:** Each chapter ends with a Chapter Complete XP callout; XP is for fun, not tracking.
- **Acronym Hygiene:** Expand acronyms on first use in each file, then rely on glossary and abbreviations include for hover tooltips.

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
- **Canonical Section Order:** Entry Checks → Outcomes → Story Intro → Labs → Validation → Exit Criteria.
- **Story Intro:** Open each chapter with 1–3 lines of narrative context that ties to the journey (why this step matters).
- **Lab Numbering:** Use hierarchical numbering per chapter (e.g., 4.1, 4.2, 4.3). Do not renumber earlier labs when adding new ones; append 4.6, 4.7, etc.
- **Footer Nav Only:** Do not include inline “## Next/Previous” sections in pages. Rely on MkDocs Material’s footer navigation.
- **Icons/Emojis:** Keep subtle. Use the page front‑matter 'icon:' and occasional emojis in intros only.
- **Admonition Titles:** Keep short, sentence case (e.g., "Note", "Tip").

### Canonical Page Skeleton

```markdown
---
icon: material/<page-icon>
---
# <Page Title>

## Entry Checks
- [ ] <pre-req 1>
- [ ] <pre-req 2>

## Outcomes
- <what you will have at the end>

<1–3 line Story Intro>

## Labs
### <chapter>.<lab> <Lab Title>
- Step bullets…
### <chapter>.<lab+1> <Lab Title>
- Step bullets…

## Validation
- [ ] Checks…

## Exit Criteria
- [ ] Checks…

> 🎉 Chapter Complete! You’ve earned up to XX XP (like Whose Line, the points are made up but the fun is real).
```

### Navigation Policy

- Footer navigation is the source of truth for Previous/Next.
- Remove any inline navigation blocks from markdown pages.

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

## Decision — 2025-08-31 16:54:54Z

Decision: Refresh AI Context and Repo Map
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

> 🎉 AI Context refreshed! You’ve earned +20 XP (like Whose Line, the points are made up but the fun is real).
