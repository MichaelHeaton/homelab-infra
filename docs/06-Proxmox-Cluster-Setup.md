---
icon: material/server
---
# Proxmox Cluster Setup

## Overview
This chapter covers preparing a 3-node Proxmox cluster, including cluster creation, storage wiring, and VM networking.

## Outcomes
- Proxmox installed and nodes joined into a cluster
- Cluster storage configured and accessible
- Networks segmented (mgmt, storage, workloads)
- Baseline VMs created for Consul + Vault

## Entry Checks
- Hardware nodes available and reachable on the network
- Admin workstation can reach Proxmox web UI
- VLANs planned and documented

## Labs
- Lab 1: Create Proxmox cluster across NodeA, NodeB, NodeC
- Lab 2: Configure mgmt VLAN and ACLs (allow Jump Box, CI, admin)
- Lab 3: Set up nightly snapshots to PBS/NAS (and offsite optional)
- Lab 4: Deploy 3-node Consul + Vault clusters spread across nodes

## Validation
- Cluster health shows quorum and all nodes online
- Test backup snapshot to NAS completes successfully
- Consul + Vault VMs boot and respond to CLI

## TODO
- [ ] Review the [Proxmox helper script](https://tteck.github.io/Proxmox/) and document its functions once reaching this chapter.
