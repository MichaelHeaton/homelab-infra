---
icon: material/server
---
# Deployment Choices for Control Plane
- Consul + Vault run as 3-node VM clusters on Proxmox
- Placement: spread across NodeA, NodeB, NodeC
- Networks: mgmt VLAN only, ACL allowlist (Jump Box, CI, admin)
- Backups: nightly snapshots to PBS/NAS, offsite optional

