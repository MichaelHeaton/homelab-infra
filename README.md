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
3. Use the provided scripts and workflows for setup and deployment

## Usage

To preview documentation locally:

```bash
python3 -m venv .venv
source .venv/bin/activate
pip install -r requirements.txt
make docs-serve
```

To build static site:

```bash
make docs-build
```

Deployment is handled automatically via GitHub Actions to the `gh-pages` branch.

## Contributing

Contributions are welcome! Please submit pull requests or issues for improvements or bug fixes.

## Runbook Template

If you need to create a new runbook, start from the template at
[`.github/RUNBOOK_TEMPLATE.md`](.github/RUNBOOK_TEMPLATE.md).
Copy it into `docs/runbooks/` and add it to `mkdocs.yml` under the Runbooks section.
