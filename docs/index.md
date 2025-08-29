# Root Access: IaC Homelab from Scratch

> **DAT:** *Define Acronyms and Terms — your hacker’s codex for jargon, slang, and domain-specific language.*  
> Consult the [Glossary](glossary.md) for all the encrypted definitions and first-use expansions.

Welcome to the **Ops Manual** — your field guide for hacking together a homelab from the ground up.  
Embark on a journey through levels, starting from your trusty laptop and evolving into a fully automated on-premises fortress.  
Each step is a quest to build, configure, and conquer your infrastructure with Infrastructure as Code (IaC).

---
## 💻 What We Mean by "Workstation"

In this quest, your *workstation* is the rig you’ll wield to initiate your homelab exploits.  
It could be a **desktop, laptop, or PC** — whatever hardware you have in your digital arsenal.  
No need for a supercomputer; we start with what you’ve got and level up from there.

---

## 🚀 Learning Path

Your mission unfolds across these chapters, each a vital level in your homelab campaign:

- Chapter 0 — **Boot Sequence: Hardware & Workstation Setup**  
- Chapter 1 — **Core Services Online**  
- Chapter 2 — **Network Layer Engaged**  
- Chapter 3 — **Storage Vaults & Backups**  
- Chapter 4 — **Observability Grid**  
- Chapter 5 — **Security Perimeter**  
- Chapter 6 — **Applications & Payloads**

---

## ❓ Do You Want To Know More?

- [Glossary](glossary.md) — DAT: your hacker’s codex for all acronyms, jargon, slang, and domain terms.  
- [Runbooks](runbooks/) — step-by-step exploits and procedures.  
- [Migration](migration.md) — strategies for shifting workloads to new hardware nodes.  
- [Control Plane](control-plane.md) — cloud-hosted orchestration & services.

---

## 🔧 Project Details

This manual is powered by [MkDocs Material](https://squidfunk.github.io/mkdocs-material/) and [GitHub Pages](https://pages.github.com/) — think of it as the console where we write our ops logs.

Contributions are welcome! See the GitHub repo: [MichaelHeaton/homelab-infra](https://github.com/MichaelHeaton/homelab-infra).
## Learning Path (vNext)

1. Workstation Setup
2. Cloud Accounts & Foundations [HCP TF state, ticket system; Vault container on workstation or NAS]
3. NAS Setup [Synology Docker workloads optional]
4. Proxmox Cluster Setup
5. CI/CD for Terraform
6. Image Factory [Packer via CI]
7. Core Infra VMs [Jump Box, PBS, Postgres, Consul, Vault]
8. Docker Swarm cluster [K8s later]
9. Traefik + Authentik + Public DNS + VPN
10. Integration Pass #1 [import to TF, Consul, Vault]
11. Migrations & Refactor [TF state choice, Vault → HA]
12. Observability + Alerting [Prom, Loki, Grafana, Slack/email/SMS]
13. Ops Readiness [Backups, DR, runbooks, SLOs, Local Status]
14. Local DNS (Pi-hole/CoreDNS/Bind)
15. DMZ & Routing
16. Public Status page + alerting
17. Workloads [Plex, Game Servers, Family Photos]
18. Graduation

## Learning Path (vNext)

1. Workstation Setup
2. Cloud Accounts & Foundations [HCP TF state, ticket system; Vault container on workstation or NAS]
3. NAS Setup [Synology Docker workloads optional]
4. Proxmox Cluster Setup
5. CI/CD for Terraform
6. Image Factory [Packer via CI]
7. Core Infra VMs [Jump Box, PBS, Postgres, Consul, Vault]
8. Docker Swarm cluster [K8s later]
9. Traefik + Authentik + Public DNS + VPN
10. Integration Pass #1 [import to TF, Consul, Vault]
11. Migrations & Refactor [TF state choice, Vault → HA]
12. Observability + Alerting [Prom, Loki, Grafana, Slack/email/SMS]
13. Ops Readiness [Backups, DR, runbooks, SLOs, Local Status]
14. Local DNS (Pi-hole/CoreDNS/Bind)
15. DMZ & Routing
16. Public Status page + alerting
17. Workloads [Plex, Game Servers, Family Photos]
18. Graduation

## Learning Path (vNext)

1. Workstation Setup
2. Cloud Accounts & Foundations [HCP TF state, ticket system; Vault container on workstation or NAS]
3. NAS Setup [Synology Docker workloads optional]
4. Proxmox Cluster Setup
5. CI/CD for Terraform
6. Image Factory [Packer via CI]
7. Core Infra VMs [Jump Box, PBS, Postgres, Consul, Vault]
8. Docker Swarm cluster [K8s later]
9. Traefik + Authentik + Public DNS + VPN
10. Integration Pass #1 [import to TF, Consul, Vault]
11. Migrations & Refactor [TF state choice, Vault → HA]
12. Observability + Alerting [Prom, Loki, Grafana, Slack/email/SMS]
13. Ops Readiness [Backups, DR, runbooks, SLOs, Local Status]
14. Local DNS (Pi-hole/CoreDNS/Bind)
15. DMZ & Routing
16. Public Status page + alerting
17. Workloads [Plex, Game Servers, Family Photos]
18. Graduation
