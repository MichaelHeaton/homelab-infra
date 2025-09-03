# Homelab Infra

This repository contains infrastructure as code (IaC) and documentation for building and managing a homelab environment using free cloud services and local hardware.

## Status & Docs

[![Build and Deploy Docs](https://github.com/MichaelHeaton/homelab-infra/actions/workflows/pages.yml/badge.svg)](https://github.com/MichaelHeaton/homelab-infra/actions/workflows/pages.yml)

**Live Docs:** https://michaelheaton.github.io/homelab-infra/

## Overview

- Infrastructure provisioning with Terraform and Ansible
- VM and container management on Proxmox and Docker
- Documentation generated with MkDocs and GitHub Pages

## Repository Structure

- `docs/` — MkDocs documentation source
- `docs/runbooks/` — operational runbooks published to docs
- `.github/` — GitHub Actions workflows and contributor templates
- `requirements.txt` — Python requirements for docs build
- `mkdocs.yml` — MkDocs site configuration

## Getting Started

1. Clone the repository
2. Follow the step-by-step guides in the `docs/` directory
3. Use the commands in **Usage** to preview/build docs locally

## Usage

### One-time setup

```bash
python3 -m venv .venv
source .venv/bin/activate
pip install -r requirements.txt
```

### Start the docs server (local preview)

If a Makefile with targets is **not** available on your branch, run MkDocs directly:

```bash
source .venv/bin/activate
mkdocs serve -a 0.0.0.0:8000
```

If your branch **does** include Makefile shortcuts, you can use:

```bash
make docs-serve      # equivalent to: mkdocs serve -a 0.0.0.0:8000
```

### Re-start later

```bash
source .venv/bin/activate
mkdocs serve -a 0.0.0.0:8000
```

### Build static site locally (optional)

```bash
mkdocs build
```

### Deployment

Docs are deployed by GitHub Actions to the `gh-pages` branch when changes are merged to `main`.

## Using Ansible

All Ansible content is stored under the `ansible/` directory. Best practice is to run playbooks from the **repo root** so paths resolve consistently.

Example commands:

```bash
# Dry-run a playbook (check mode)
ansible-playbook ansible/playbooks/05_network_config.yml --check

# Apply to a single host
ansible-playbook -l gpu01 ansible/playbooks/05_network_config.yml

# Run facts gathering
ansible-playbook ansible/playbooks/01_network_facts.yml
```

Notes:
- `ansible/ansible.cfg` is symlinked at repo root as `./ansible.cfg` so it is always picked up.
- Inventory is located at `ansible/inventories/hosts.yml`.
- Templates are under `ansible/templates/`.

## Contributing

Contributions are welcome! Please submit pull requests or issues for improvements or bug fixes.

## Runbook Template

If you need to create a new runbook, start from the template at
[`.github/RUNBOOK_TEMPLATE.md`](.github/RUNBOOK_TEMPLATE.md).
Copy it into `docs/runbooks/` and add it to `mkdocs.yml` under the Runbooks section.
