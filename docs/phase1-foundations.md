---
icon: material/hammer-wrench
---
# Phase 1 — Hardware Baseline
**Goal:** establish substrate before any VMs.

## 1.1 Network
- 1.1.1 Setup VLANs, DHCP, baseline firewalls (any VLAN-capable gear)
- 1.1.2 Base VLAN design

| VLAN ID | Name            | Subnet         | Notes |
|-------:|-----------------|----------------|-------|
| 10     | Management      | 172.16.10.0/24 | Admin workstations, Jump Box |
| 20     | Family/Users    | 172.16.20.0/24 | User devices |
| 30     | Storage         | 172.16.30.0/24 | NAS, PBS |
| 40     | Services        | 172.16.40.0/24 | DNS, Proxy, Identity |
| 50     | Guest/IoT       | 172.16.50.0/24 | Internet only |
| 99     | Transit/Default | as needed      | Setup only |

## 1.2 Proxmox cluster setup (NodeA, NodeB, NodeC)
## 1.3 NAS shares online (NFS/SMB/iSCSI)
- 1.3.1 Define share/target layout

## 1.4 Checkpoint
- 1.4.1 ISO library available
- 1.4.2 VLAN routing/firewall validated

