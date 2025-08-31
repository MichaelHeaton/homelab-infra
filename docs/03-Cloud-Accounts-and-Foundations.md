---
icon: material/cloud
---
# Cloud Accounts & Foundations

**Overview**
This chapter sets up core cloud accounts and authenticates CLI tools needed for DNS, source control, and container registries.
We will also configure HashiCorp Cloud Platform (HCP) Terraform to store state remotely.

## Outcomes
- GitHub account and CLI authenticated
- Cloudflare account and Wrangler authenticated
- Docker Hub account and CLI authenticated
- Optional: HashiCorp Cloud tools (Vault, Consul, Terraform)
- HCP Terraform workspace created for remote state storage

## Entry Checks
- Workstation setup complete with required CLIs installed (gh, wrangler, docker, terraform, vault, consul)
- HCP Terraform account created and accessible

---

## 🌐 Cloud Accounts

Before continuing, ensure you have the following accounts created:

- [GitHub](https://github.com){:target="_blank"} (for source control & CI/CD)
- [Cloudflare](https://www.cloudflare.com){:target="_blank"} (for DNS & security)
- [Docker Hub](https://hub.docker.com){:target="_blank"} (for container images)
- [HashiCorp Cloud](https://cloud.hashicorp.com){:target="_blank"} (for Vault/Consul/Terraform Cloud if desired)

---

## Labs

### Lab 1: ![GitHub Logo](https://img.icons8.com/ios-glyphs/20/github.png) GitHub CLI

The GitHub CLI (`gh`) helps you manage GitHub repositories, pull requests, and authentication from your terminal.
- Official docs: [GitHub CLI Documentation](https://cli.github.com/){:target="_blank"}

Authenticate with GitHub using:

```bash
gh auth login
```

---

### Lab 2: ![Cloudflare Logo](https://img.icons8.com/ios/20/cloud.png) Cloudflare CLI (Wrangler)

Wrangler is Cloudflare’s CLI for managing DNS, Workers, and KV namespaces.
- Official docs: [Wrangler Documentation](https://developers.cloudflare.com/workers/wrangler/){:target="_blank"}

Authenticate with Cloudflare using:

```bash
wrangler login
```

---

### Lab 3: 🐳 Docker CLI

The Docker CLI is used to manage containers and also serves as the interface for Docker Hub logins.
- Official docs: [Docker CLI Docs](https://docs.docker.com/engine/reference/commandline/cli/){:target="_blank"}

Authenticate with Docker Hub using:

```bash
docker login
```

---

### Lab 4: ![HashiCorp Logo](https://img.icons8.com/ios/20/hashicorp.png) HashiCorp CLI Tools

These tools are optional but recommended if you plan to use Vault, Consul, or Terraform Cloud.
- [Terraform CLI](https://developer.hashicorp.com/terraform/cli){:target="_blank"}
- [Vault CLI](https://developer.hashicorp.com/vault/docs/commands){:target="_blank"}
- [Consul CLI](https://developer.hashicorp.com/consul/docs/commands){:target="_blank"}

---

### Lab 5: 🌐 HCP Terraform Remote State

HCP Terraform provides a secure and centralized place to store Terraform state files.

- Official docs: [HCP Terraform](https://developer.hashicorp.com/terraform/cloud-docs){:target="_blank"}

1. Log in to HCP Terraform:

    ```bash
    terraform login
    ```

    Follow the prompts to generate and paste an API token.

2. Create a new workspace in your HCP Terraform organization (via web UI or CLI).

3. Update your Terraform configuration to use the remote backend. Example:

    ```hcl
    terraform {
      backend "remote" {
        organization = "your-org-name"

        workspaces {
          name = "homelab-infra"
        }
      }
    }
    ```

4. Initialize the backend:

    ```bash
    terraform init
    ```

This ensures your Terraform state is safely stored in HCP Terraform.

## Validation

Verify that all tools are installed and authenticated correctly by running:

```bash
gh --version
gh auth status

wrangler --version
wrangler whoami

docker --version
docker info

terraform version
vault status
consul version

terraform state list   # should connect to remote backend without error
```

Make sure each command returns the expected version or status without errors before proceeding.

---

## Exit Criteria

- [ ] GitHub CLI authenticated
- [ ] Cloudflare Wrangler authenticated
- [ ] Docker CLI authenticated
- [ ] (Optional) HashiCorp tools validated
- [ ] HCP Terraform remote state configured and validated
