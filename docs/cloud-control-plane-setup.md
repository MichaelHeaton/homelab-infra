---
icon: material/cloud
---
# Cloud Control Plane Setup

**Goal:** Set up the foundational tools and accounts needed for managing your homelab from the cloud.

## App Configuration  
After installing the tools on your workstation, follow these steps to configure them for use in your cloud control plane.

- HashiCorp Vault configuration → [docs/runbooks/vault_bootstrap_runbook.md](runbooks/vault_bootstrap_runbook.md)  
- Terraform backend setup  
- Consul cluster setup  
- etc.  
---

## 🌐 Cloud Accounts

Before continuing, ensure you have the following accounts created:

- [GitHub](https://github.com) (for source control & CI/CD)  
- [Cloudflare](https://www.cloudflare.com) (for DNS & security)  
- [Docker Hub](https://hub.docker.com) (for container images)  
- [HashiCorp Cloud](https://cloud.hashicorp.com) (for Vault/Consul/Terraform Cloud if desired)  

---

## ⚡ Cloud Bootstrap

This section covers authenticating the CLI tools you’ll need to manage your cloud control plane. Make sure the tools are already installed on your system before proceeding.

### ![GitHub Logo](https://img.icons8.com/ios-glyphs/20/github.png) GitHub CLI

The GitHub CLI (`gh`) helps you manage GitHub repositories, pull requests, and authentication from your terminal.  
- Official docs: [GitHub CLI Documentation](https://cli.github.com/)

Authenticate with GitHub using:

```bash
gh auth login
```

---

### ![Cloudflare Logo](https://img.icons8.com/ios/20/cloud.png) Cloudflare CLI (Wrangler)

Wrangler is Cloudflare’s CLI for managing DNS, Workers, and KV namespaces.  
- Official docs: [Wrangler Documentation](https://developers.cloudflare.com/workers/wrangler/)

Authenticate with Cloudflare using:

```bash
wrangler login
```

---

### 🐳 Docker CLI

The Docker CLI is used to manage containers and also serves as the interface for Docker Hub logins.  
- Official docs: [Docker CLI Docs](https://docs.docker.com/engine/reference/commandline/cli/)

Authenticate with Docker Hub using:

```bash
docker login
```

---

### ![HashiCorp Logo](https://img.icons8.com/ios/20/hashicorp.png) HashiCorp CLI Tools

These tools are optional but recommended if you plan to use Vault, Consul, or Terraform Cloud.  
- [Terraform CLI](https://developer.hashicorp.com/terraform/cli)  
- [Vault CLI](https://developer.hashicorp.com/vault/docs/commands)  
- [Consul CLI](https://developer.hashicorp.com/consul/docs/commands)

---

## ✅ Checkpoint

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
```

Make sure each command returns the expected version or status without errors before proceeding.
