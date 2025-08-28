---
icon: material/shield-lock
---
# Phase 5 — Core Local Services
**Goal:** deploy platform services fully on-prem.

## 5.1 DNS (Pi-hole or CoreDNS or Bind)
## 5.2 Traefik reverse proxy with Cloudflare DNS-01 for TLS
## 5.3 Authentik for identity and SSO
## 5.4 Prometheus + Loki + Grafana for monitoring/logging
## 5.5 Deployment style
- 5.5.1 All run as Docker containers on the Docker host VM(s).

## 5.6 Checkpoint
- 5.6.1 TLS enforced across services
- 5.6.2 SSO working for Grafana and admin portals
- 5.6.3 Logs and metrics flowing into observability stack

