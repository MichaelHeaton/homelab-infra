---
icon: material/server
---
# Proxmox Cluster Setup

!!! info "Quick Overview"
    **What:** Prepare and build a 3-node Proxmox cluster with storage and networking.
    **Why:** Clustering unlocks High Availability (HA), shared storage, and scaling for your homelab.
    **Time:** 90–150 minutes.
    **XP:** Up to 100 points (like Whose Line, the points are made up but the fun is real).

## Outcomes
- Proxmox installed and nodes joined into a cluster
- Cluster storage configured and accessible
- Networks segmented (management, storage, workloads)
- Baseline Virtual Machines (VMs) created for Consul + Vault

Now it’s time to link your nodes into a unified cluster. Proper Network Interface Card (NIC) setup, storage connections, and VM baselines will give you a resilient backbone for your homelab.

## Entry Checks
- Hardware nodes available and reachable on the network
- Admin workstation can reach Proxmox web User Interface (UI)
- Virtual Local Area Networks (VLANs) planned and documented

## Labs

### 6.1 NIC Setup for single vs multiple Network Interface Cards (NICs)
Explain benefits and that Network Interface Cards (NICs) should be configured before cluster creation.

#### Validation
- [ ] Network Interface Cards (NICs) configured before cluster join
🏆 Achievement Unlocked: Network interfaces ready!

### 6.2 Create Proxmox cluster across NodeA, NodeB, NodeC

#### Validation
- [ ] Cluster created with quorum
🏆 Achievement Unlocked: Cluster formed!

### 6.3 Configure management VLAN and Access Control Lists (ACLs) (allow Jump Box, Continuous Integration (CI), admin)

#### Validation
- [ ] Management VLAN and Access Control Lists (ACLs) verified
🏆 Achievement Unlocked: Secure management lanes!

### 6.4 Connect to Network Attached Storage (NAS) via Network File System (NFS) and Internet Small Computer Systems Interface (iSCSI)

#### Validation
- [ ] Network File System (NFS) mount verified
- [ ] Internet Small Computer Systems Interface (iSCSI) Logical Unit Number (LUN) attached
🏆 Achievement Unlocked: Shared storage online!

### 6.5 Set up nightly snapshots to Proxmox Backup Server (PBS)/NAS (and offsite optional)

#### Validation
- [ ] Backup snapshot completed
🏆 Achievement Unlocked: Snapshots scheduled!

### 6.6 Deploy 3-node Consul + Vault clusters spread across nodes

#### Validation
- [ ] Consul cluster booted
- [ ] Vault cluster sealed and reachable
🏆 Achievement Unlocked: Service backbone deployed!

## Exit Criteria

> 🎉 Chapter Complete! You’ve earned up to 100 XP (like Whose Line, the points are made up but the fun is real). Proxmox cluster online!
