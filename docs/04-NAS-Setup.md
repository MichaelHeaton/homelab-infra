---
icon: material/harddisk
---
# NAS Setup

## Overview
This chapter covers preparing a Synology NAS for homelab use, including shares, permissions, exports, snapshots, and optional Docker workloads. NAS will also be the foundation for VM storage and backups.

## Outcomes
- Shares and permissions codified via UI or automation
- NFS/SMB exports ready for Proxmox and other hosts
- Snapshot policy baseline defined and validated
- Optional: NAS Docker environment enabled for seed services

## Entry Checks
- Synology NAS reachable on the network
- Admin credentials available
- Workstation can reach DSM web console

## Labs
- **Lab 1:** Detect & import existing shares and NFS exports
- **Lab 2:** Create required shares per role (media, backups, workloads)
- **Lab 3:** Define and apply snapshot policy
- **Lab 4 (Optional):** Enable Docker and run seed services (ticket, Vault)

## Validation
- Hosts mount NFS/SMB successfully
- Snapshots are visible and match policy
- Optional Docker containers run correctly

## Exit Criteria
- [ ] Shares and exports are configured and validated
- [ ] Snapshot policies active
- [ ] Optional Docker workloads deployed (if enabled)
