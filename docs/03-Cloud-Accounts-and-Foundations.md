---
icon: material/cloud
---
# Cloud Accounts & Foundations

**Overview**
This chapter sets up core cloud accounts and authenticates CLI tools needed for DNS, source control, and container registries.

## Outcomes
- GitHub account and CLI authenticated
- Cloudflare account and Wrangler authenticated
- Docker Hub account and CLI authenticated
- Optional: HashiCorp Cloud tools (Vault, Consul, Terraform)

## Entry Checks
- Workstation setup complete with required CLIs installed (gh, wrangler, docker, terraform, vault, consul)

---

## 🌐 Cloud Accounts

Before continuing, ensure you have the following accounts created:

- [GitHub](https://github.com) (for source control & CI/CD)
- [Cloudflare](https://www.cloudflare.com) (for DNS & security)
- [Docker Hub](https://hub.docker.com) (for container images)
- [HashiCorp Cloud](https://cloud.hashicorp.com) (for Vault/Consul/Terraform Cloud if desired)

---

## Labs

### Lab 1: ![GitHub Logo](https://img.icons8.com/ios-glyphs/20/github.png) GitHub CLI

The GitHub CLI (`gh`) helps you manage GitHub repositories, pull requests, and authentication from your terminal.
- Official docs: [GitHub CLI Documentation](https://cli.github.com/)

Authenticate with GitHub using:

```bash
gh auth login
```

---

### Lab 2: ![Cloudflare Logo](https://img.icons8.com/ios/20/cloud.png) Cloudflare CLI (Wrangler)

Wrangler is Cloudflare’s CLI for managing DNS, Workers, and KV namespaces.
- Official docs: [Wrangler Documentation](https://developers.cloudflare.com/workers/wrangler/)

Authenticate with Cloudflare using:

```bash
wrangler login
```

---

### Lab 3: 🐳 Docker CLI

The Docker CLI is used to manage containers and also serves as the interface for Docker Hub logins.
- Official docs: [Docker CLI Docs](https://docs.docker.com/engine/reference/commandline/cli/)

Authenticate with Docker Hub using:

```bash
docker login
```

---

### Lab 4: ![HashiCorp Logo](https://img.icons8.com/ios/20/hashicorp.png) HashiCorp CLI Tools

These tools are optional but recommended if you plan to use Vault, Consul, or Terraform Cloud.
- [Terraform CLI](https://developer.hashicorp.com/terraform/cli)
- [Vault CLI](https://developer.hashicorp.com/vault/docs/commands)
- [Consul CLI](https://developer.hashicorp.com/consul/docs/commands)

---

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
```

Make sure each command returns the expected version or status without errors before proceeding.

---

## Exit Criteria

- [ ] GitHub CLI authenticated
- [ ] Cloudflare Wrangler authenticated
- [ ] Docker CLI authenticated
- [ ] (Optional) HashiCorp tools validated
