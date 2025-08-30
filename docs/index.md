# Root Access: IaC Homelab from Scratch

> **DAT** — Define Acronyms & Terms. See the [Glossary](glossary.md) for full definitions.
> Acronyms like IaC, CI/CD, PBS, and others will show hover definitions automatically.

Welcome to the **Ops Manual** — your field guide for hacking together a homelab from the ground up.
Embark on a journey through levels, starting from your trusty laptop and evolving into a fully automated on-premises fortress.
Each step is a quest to build, configure, and conquer your infrastructure with IaC.

---
## 💻 What We Mean by "Workstation"

In this quest, your *workstation* is the rig you’ll wield to initiate your homelab exploits.
It could be a **desktop, laptop, or PC** — whatever hardware you have in your digital arsenal.
No need for a supercomputer; we start with what you’ve got and level up from there.

---

## 🚀 Learning Path

1. Hardware
2. Workstation Setup
3. Cloud Accounts & Foundations
4. NAS Setup
5. Proxmox Cluster Setup
6. CI/CD for Terraform
7. Image Factory
8. Core Infra VMs (Jump Box, PBS, Postgres, Consul, Vault)
9. Docker Swarm Cluster (K8s later)
10. Traefik + Authentik + Public DNS + VPN
11. Integration Pass (import to TF, Consul, Vault)
12. Migrations & Refactor (TF state choice, Vault to HA)
13. Observability + Alerting (Prom, Loki, Grafana, Slack, email, SMS)
14. Ops Readiness (Backups, DR, runbooks, SLOs, Local Status)
15. Local DNS (Pi-hole/CoreDNS/Bind)
16. DMZ & Routing
17. Public Status Page + Alerting
18. Workloads (Plex, Game Servers, Family Photos)
19. Graduation

---

## ❓ Do You Want To Know More?

- [Glossary](glossary.md) — DAT: your hacker’s codex for all acronyms, jargon, slang, and domain terms.
- [Runbooks](runbooks/resolve_conflicts.md) — step-by-step exploits and procedures.
- [Migration](12-Migrations-and-Refactor.md) — strategies for shifting workloads to new hardware nodes.
- [Control Plane](05-Proxmox-Cluster-Setup.md) — cloud-hosted orchestration & services.

---

## 🔧 Project Details

This manual is powered by [MkDocs Material](https://squidfunk.github.io/mkdocs-material/) and [GitHub Pages](https://pages.github.com/) — think of it as the console where we write our ops logs.

Contributions are welcome! See the GitHub repo: [MichaelHeaton/homelab-infra](https://github.com/MichaelHeaton/homelab-infra).

--8<-- "includes/abbreviations.md"
