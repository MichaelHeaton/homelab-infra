# Phase 3 — First 3 VMs on Proxmox + Docker Swarm
**Goal:** first managed VMs and container orchestration.

## 3.1 VM #1: Jump Box
- 3.1.1 Built from golden image
- 3.1.2 Managed with Ansible
- 3.1.3 Verified monitoring + Vault access

## 3.2 VM #2: Proxmox Backup Server (PBS)
- 3.2.1 PBS **VM**, datastore **on NAS**
- 3.2.2 Validate backup/restore of templates and Jump Box

## 3.3 VM #3: Docker Host (Manager)
- 3.3.1 From golden image
- 3.3.2 Initialize **Docker Swarm**

## 3.4 Checkpoint
- 3.4.1 Jump Box reachable only from mgmt VLAN
- 3.4.2 PBS completes a full backup and a test restore
- 3.4.3 `docker node ls` shows manager ready

