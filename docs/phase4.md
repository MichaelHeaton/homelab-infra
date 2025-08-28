# Phase 4 — Local Control Plane (HA)
**Goal:** replace cloud control plane with local HA equivalents.

## 4.1 Consul 3-node cluster (VMs on Proxmox)
- 4.1.1 KV store, Terraform state backend
- 4.1.2 Snapshots to PBS/NAS

## 4.2 Vault 3-node cluster (VMs on Proxmox)
- 4.2.1 Integrated storage
- 4.2.2 Unseal via shamir (auto-unseal later)

## 4.3 Docker Swarm worker VMs
- 4.3.1 Create 2 worker VMs
- 4.3.2 Add nodes to Swarm

## 4.4 Migrations
- 4.4.1 Terraform backend: HCP → Consul KV
- 4.4.2 Vault: HCP Vault → local Vault

## 4.5 Update Image Factory for Consul support

## 4.6 Checkpoint
- 4.6.1 Terraform `plan` is no-op post-migration
- 4.6.2 Apps re-seeded with local Vault creds

