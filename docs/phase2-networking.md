---
icon: material/lan
---
# Networking & Access

## Overview
UniFi-first. Terraform → Ansible → Python. Detect & import existing config.

## Outcomes
- VLANs and DHCP codified
- Wireless SSIDs [Admin, Family, Guest, IoT] mapped to VLANs
- Baseline ACLs, mDNS exceptions

## Entry Checks
- UniFi controller reachable
- Site slug known (TBD)

## Labs
1) Discover and `terraform import` networks, SSIDs, user groups
2) Add missing VLANs and SSIDs with client isolation
3) Store PSKs and controller creds in Vault

## Validation
- Inter-VLAN policy tests pass
- SSID auth works; isolation enforced

## Next
→ Storage & Backups
