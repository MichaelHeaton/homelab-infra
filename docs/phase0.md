# Phase 0 — Workstation + Cloud Control Plane
**Goal:** start with only a laptop and free services.

## 0.1 Workstation/Laptop Setup
- 0.1.1 Install Docker Desktop (or Podman)
- 0.1.2 Install Terraform + Ansible
- 0.1.3 Install Git and VS Code

## 0.2 Create Cloud Accounts
- 0.2.1 GitHub
- 0.2.2 HashiCorp
- 0.2.3 Cloudflare

## 0.3 Cloud Bootstrap
- 0.3.1 Create `homelab-infra` repo
- 0.3.2 HCP Terraform Free → remote state + locking
- 0.3.3 HCP Vault Dev → initial secrets store
- 0.3.4 GitHub Actions CI wired to plan/apply

## 0.4 Checkpoint
- 0.4.1 `terraform plan` runs from laptop and CI
- 0.4.2 Secrets retrieved from Vault
- 0.4.3 Repo bootstrapped with first module

