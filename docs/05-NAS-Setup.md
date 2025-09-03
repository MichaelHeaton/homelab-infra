---
icon: material/harddisk
---
# NAS Setup

!!! info "Quick Overview"
    **What:** Prepare a Synology NAS (and optional UNAS) for homelab use.
    **Why:** NAS is the foundation for VM storage, PBS backups, media, and container data.
    **Time:** 60–120 minutes.
    **XP:** Up to 90 points.

## Entry Checks
- Synology NAS reachable on the network
- Admin credentials available
- Workstation can reach DSM web console

## Outcomes
- Shares and permissions codified via UI or automation
- NFS/iSCSI/SMB exports ready for Proxmox, PBS, and other hosts
- Snapshot policy baseline defined and validated
- NAS01 NTP service enabled for LAN fallback
- Optional: lightweight Docker environment enabled for seed services (Portainer, CI/CD tools)

Storage is where your homelab lives. This chapter gets your Synology and UNAS ready for shares, snapshots, and even container workloads.

## Labs

### Lab 1: Detect & import existing shares and NFS exports

#### Validation
- [ ] Existing exports detected and mounted
🏆 Achievement Unlocked: Legacy shares imported!

### Lab 2: Create required shares and LUNs grouped by NFS or iSCSI roles (media, backups, workloads).

#### Validation
- [ ] New shares and LUNs created
🏆 Achievement Unlocked: Storage provisioned!

### Lab 3: Define and apply snapshot policy

#### Validation
- [ ] Snapshot policy applied
🏆 Achievement Unlocked: Snapshots secured!

### Lab 4: Setup Portainer (UI for managing containers)

#### Validation
- [ ] Portainer accessible
🏆 Achievement Unlocked: Portainer helm on deck!

### Lab 5.1: Planned NAS Layout (iSCSI, NFS, default shares)

### iSCSI Shares
- `vm-store` (Proxmox VM datastore, default)
- `pbs-backups` (Proxmox Backup Server datastore)
- `db-lun` (Databases needing block storage, optional)
- `docker-lun` (Persistent container data, optional)
- `k8s-pv` (Kubernetes persistent volumes, optional)

### NFS Shares
- `/Homes` (user home directories, Synology default)
- `/Photo` (Synology Photos service)
- `/Download` (general downloads, optional)
- `/Media` (Plex and related media storage, served from NAS02)

NAS01 is primary for VM/backup workloads. NAS02 is reserved for media (NFS only).

**Default Synology Shares**
- `/home` and `/homes` (keep – user private directories, family network homes)
- `/photo` (keep – required for Synology Photos app)
- `/music` (drop – only used by Audio Station, not needed with Plex)
- `/video` (drop – only used by Video Station, Plex/UNAS will be used instead)
- `/surveillance` (skip – only created if Surveillance Station is enabled)
- `/docker` (drop – only used for Synology Docker, not needed with Portainer/Proxmox)

#### Validation
- [ ] Layout documented and approved
🏆 Achievement Unlocked: NAS blueprint created!

### Lab 5.2: Detect & import existing shares and NFS exports

#### Validation
- [ ] Existing exports detected and mounted
🏆 Achievement Unlocked: Legacy shares imported!

### Lab 5.3: Create required shares and LUNs grouped by NFS or iSCSI roles (media, backups, workloads).

#### Validation
- [ ] New shares and LUNs created
🏆 Achievement Unlocked: Storage provisioned!

### Lab 5.4: Define and apply snapshot policy

#### Validation
- [ ] Snapshot policy applied
🏆 Achievement Unlocked: Snapshots secured!

### Lab 5.5: Setup Portainer (UI for managing containers)

#### Validation
- [ ] Portainer accessible
🏆 Achievement Unlocked: Portainer helm on deck!

### Lab 5.6: Deploy Consul (service discovery and configuration, backend for Vault)

#### Validation
- [ ] Consul running
🏆 Achievement Unlocked: Consul online!

### Lab 5.7: Deploy Vault (secrets management)

#### Validation
- [ ] Vault running
🏆 Achievement Unlocked: Vault sealed and ready!

### Lab 5.8: Deploy Homepage (landing page for services)

#### Validation
- [ ] Homepage reachable
🏆 Achievement Unlocked: Dashboard launched!

### Lab 5.A: Introduction to RAID, NFS, and iSCSI (explanation and why they matter in homelab setup)

### Lab 5.B: Best practices for setting up a NAS/Synology (covering user management, folder structure, snapshots, and backups) Also configure the NAS to provide NTP service for the LAN (Control Panel → Regional Options → Time → NTP Service).

## Background Concepts
- **RAID:** A method of combining multiple hard drives into a single unit to improve performance and/or provide redundancy to protect data in case of drive failure.
- **NFS (Network File System):** A protocol that allows a computer to access files over a network as if they were on local storage, commonly used for sharing files in Unix/Linux environments.
- **iSCSI (Internet Small Computer Systems Interface):** A protocol that enables block-level storage over a network, allowing systems to use remote storage devices as if they were locally attached disks.

## Exit Criteria
- [ ] Shares and exports are configured and validated
- [ ] Snapshot and replication policies active
- [ ] NAS01 NTP service enabled and validated
- [ ] Optional container workloads deployed (if enabled)
- [ ] UNAS exports validated
- [ ] Docker workloads deployed via Portainer
- [ ] Core workloads (Portainer, Homepage, Vault, Consul, PBS integration) deployed and validated

> 🎉 Chapter Complete! You’ve earned up to 90 XP. Storage fortress online!
