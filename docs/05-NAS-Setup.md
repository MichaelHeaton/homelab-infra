---
icon: material/harddisk
---
# NAS Setup

--8<-- "includes/abbreviations.md"


## Overview
This chapter covers preparing a Synology NAS for homelab use, including shares, permissions, exports, snapshots, and optional Docker workloads. NAS will also be the foundation for VM storage and backups.

> **Note:** This setup uses two NAS devices (Synology DS1621+ and UNAS). Shares are grouped by NFS or iSCSI roles for clarity.

## Planned NAS Layout

### iSCSI Shares
- `vm-store` (Proxmox VM storage)
- `pbs-backups` (Proxmox Backup Server target)
- `db-lun` (Database workloads)
- `docker-lun` (Docker persistent data)
- `k8s-pv` (Kubernetes persistent volumes)

### NFS Shares
- `/Homes` (user home directories, Synology defaults)
- `/Photo` (Synology Photos service)
- `/Download` (general downloads)
- `/Media` (Plex and related media storage)

**Default Synology Shares**
- `/home` and `/homes` (keep – user private directories, family network homes)
- `/photo` (keep – required for Synology Photos app)
- `/music` (drop – only used by Audio Station, not needed with Plex)
- `/video` (drop – only used by Video Station, Plex/UNAS will be used instead)
- `/surveillance` (skip – only created if Surveillance Station is enabled)

## Outcomes
- Shares and permissions codified via UI or automation
- NFS/SMB exports ready for Proxmox and other hosts
- Snapshot policy baseline defined and validated
- Optional: NAS Docker environment enabled for seed services

## Entry Checks
- Synology NAS reachable on the network
- Admin credentials available
- Workstation can reach DSM web console

## Background Concepts
- **RAID:** A method of combining multiple hard drives into a single unit to improve performance and/or provide redundancy to protect data in case of drive failure.
- **NFS (Network File System):** A protocol that allows a computer to access files over a network as if they were on local storage, commonly used for sharing files in Unix/Linux environments.
- **iSCSI (Internet Small Computer Systems Interface):** A protocol that enables block-level storage over a network, allowing systems to use remote storage devices as if they were locally attached disks.

## Labs
- **Lab 1:** Detect & import existing shares and NFS exports
- **Lab 2:** Create required shares and LUNs grouped by NFS or iSCSI roles (media, backups, workloads).
- **Lab 3:** Define and apply snapshot policy
- **Lab 4:** Setup Portainer (UI for managing containers)
- **Lab 5:** Deploy Consul (service discovery and configuration, backend for Vault)
- **Lab 6:** Deploy Vault (secrets management)
- **Lab 7:** Deploy Homepage (landing page for services)

## Additional Labs
- **Lab A:** Introduction to RAID, NFS, and iSCSI (explanation and why they matter in homelab setup)
- **Lab B:** Best practices for setting up a NAS/Synology (covering user management, folder structure, snapshots, and backups)

## Validation
- Hosts mount NFS/SMB successfully
- Snapshots are visible and match policy
- Optional Docker containers run correctly
- Verify UNAS exports mount correctly from Proxmox and Synology
- Verify Docker containers managed via Portainer are running
- Verify core containers (Portainer, Homepage, Vault, Consul) are running and accessible

## Exit Criteria
- [ ] Shares and exports are configured and validated
- [ ] Snapshot policies active
- [ ] Optional Docker workloads deployed (if enabled)
- [ ] UNAS exports validated
- [ ] Docker workloads deployed via Portainer
- [ ] Core Docker workloads (Portainer, Homepage, Vault, Consul) deployed and validated
