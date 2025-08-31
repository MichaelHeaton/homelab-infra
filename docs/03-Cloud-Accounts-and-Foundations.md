---
icon: material/cloud
---
# Cloud Accounts & Foundations

!!! info "Quick Overview"
    **What:** Set up and authenticate core cloud accounts and CLIs.
    **Why:** These accounts connect your homelab to the outside world and enable automation.
    **Time:** 30–60 minutes.
    **XP:** Up to 50 points (like Whose Line, the points are made up but the fun is real).

## Entry Checks
- Workstation setup complete with required CLIs (Command Line Interfaces) installed (gh, wrangler, docker, terraform, vault, consul)
- HCP (HashiCorp Cloud Platform) Terraform account created and accessible

## Outcomes
- GitHub account and CLI (Command Line Interface) authenticated
- Cloudflare account and Wrangler authenticated
- Docker Hub account and CLI (Command Line Interface) authenticated
- Optional: HashiCorp Cloud tools (Vault, Consul, Terraform)
- HCP Terraform workspace created for remote state storage

With your workstation tools installed, it’s time to connect to the cloud. These accounts and CLIs are your lifeline to DNS, source control, container images, and Terraform state management.

---

## 🌐 Cloud Accounts

Before continuing, ensure you have the following accounts created:

- [GitHub](https://github.com){:target="_blank"} (for source control & CI/CD)
- [Cloudflare](https://www.cloudflare.com){:target="_blank"} (for DNS & security)
- [Docker Hub](https://hub.docker.com){:target="_blank"} (for container images)
- [HashiCorp Cloud](https://cloud.hashicorp.com){:target="_blank"} (for Vault/Consul/Terraform Cloud if desired)

---

## Labs

### 3.1 GitHub CLI

The GitHub CLI (Command Line Interface) (`gh`) helps you manage GitHub repositories, pull requests, and authentication from your terminal.
- Official docs: [GitHub CLI Documentation](https://cli.github.com/){:target="_blank"}

Authenticate with GitHub using:

```bash
gh auth login
```

#### Validation

- [ ] Run `gh --version`
- [ ] Run `gh auth status`

🏆 Achievement Unlocked: GitHub authenticated!

---

### 3.2 Cloudflare CLI (Wrangler)

Wrangler is Cloudflare’s CLI (Command Line Interface) for managing DNS, Workers, and KV namespaces.
- Official docs: [Wrangler Documentation](https://developers.cloudflare.com/workers/wrangler/){:target="_blank"}

Authenticate with Cloudflare using:

```bash
wrangler login
```

#### Validation

- [ ] Run `wrangler --version`
- [ ] Run `wrangler whoami`

🏆 Achievement Unlocked: Cloudflare connected!

---

### 3.3 Docker CLI

The Docker CLI (Command Line Interface) is used to manage containers and also serves as the interface for Docker Hub logins.
- Official docs: [Docker CLI Docs](https://docs.docker.com/engine/reference/commandline/cli/){:target="_blank"}

Authenticate with Docker Hub using:

```bash
docker login
```

#### Validation

- [ ] Run `docker --version`
- [ ] Run `docker info`

🏆 Achievement Unlocked: Docker docked!

---

### 3.4 HashiCorp CLI Tools

These CLI (Command Line Interface) tools are optional but recommended if you plan to use Vault, Consul, or Terraform Cloud.
- [Terraform CLI](https://developer.hashicorp.com/terraform/cli){:target="_blank"}
- [Vault CLI](https://developer.hashicorp.com/vault/docs/commands){:target="_blank"}
- [Consul CLI](https://developer.hashicorp.com/consul/docs/commands){:target="_blank"}

#### Validation

- [ ] Run `terraform version`
- [ ] Run `vault status`
- [ ] Run `consul version`

🏆 Achievement Unlocked: HashiCorp toolkit ready!

---

### 3.5 HCP Terraform Remote State

HCP Terraform provides a secure and centralized place to store Terraform state files.

- Official docs: [HCP Terraform](https://developer.hashicorp.com/terraform/cloud-docs){:target="_blank"}

1. Log in to HCP Terraform:

    ```bash
    terraform login
    ```

    Follow the prompts to generate and paste an API (Application Programming Interface) token.

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

#### Validation

- [ ] Run `terraform state list`

🏆 Achievement Unlocked: Remote state secured!

---

## Exit Criteria

- [ ] GitHub CLI authenticated
- [ ] Cloudflare Wrangler authenticated
- [ ] Docker CLI authenticated
- [ ] (Optional) HashiCorp tools validated
- [ ] HCP Terraform remote state configured and validated

> 🎉 Chapter Complete! You’ve earned up to 50 XP (like Whose Line, the points are made up but the fun is real). Your cloud foundations are live!
