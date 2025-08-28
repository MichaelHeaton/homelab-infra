# Phase 2 — Image Factory + Vagrant
**Goal:** deterministic images, no hand-built VMs yet.

## 2.1 Image Factory
- 2.1.1 Packer templates for **Ubuntu 24.04 LTS** with cloud-init
- 2.1.2 Hardened baseline: SSH, sudo, logging agents, NTP
- 2.1.3 Store golden images in Proxmox content library

## 2.2 Vagrant
- 2.2.1 Local testing before pushing to Proxmox
- 2.2.2 Enables readers without Proxmox hardware to follow along

## 2.3 Checkpoint
- 2.3.1 Golden image published, versioned
- 2.3.2 Validation done locally via Vagrant

