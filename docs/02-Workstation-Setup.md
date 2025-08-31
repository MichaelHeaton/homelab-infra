---
icon: material/laptop
---

# Workstation Setup

!!! info "Quick Overview"
    **What:** Install the essential workstation tools for building and managing your homelab.
    **Why:** These tools are your toolbox—Git, Docker, Terraform, and more.
    **Time:** 30–90 minutes depending on installs.
    **XP:** Up to 70 points (like Whose Line, the points are made up but the fun is real).

## Entry Checks

- macOS or Windows with admin rights
- Git and GitHub account
- Docker Desktop available

## Outcomes

- Install and configure Git and GitHub CLI
- Install Wrangler and validate Cloudflare login
- Install Docker Desktop and verify installation
- Install Terraform and validate setup
- (Optional) Install Ansible and validate setup on supported platforms

With your hardware ready, it’s time to prepare your workstation. These tools are the core kit that will let you manage, automate, and interact with every part of your homelab journey.

### Preparing Package Managers

=== "macOS"

    1. Install Homebrew (macOS package manager) (if not already installed):

        ```bash
        /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
        ```

=== "Windows"

    1. Install Chocolatey (Windows package manager) (if not already installed):

        ```powershell
        Set-ExecutionPolicy Bypass -Scope Process -Force; `
        [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072; `
        iex ((New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1'))
        ```

    2. Install curl (if not already available):

        ```powershell
        choco install curl
        ```

    3. Validate:

        ```powershell
        curl --version
        ```

## Labs

### 2.1 Git and GitHub CLI

!!! info "Git and GitHub CLI"
    Git is a distributed version control system. GitHub CLI brings GitHub actions to your terminal. These are essential for managing infrastructure code and collaborating on the homelab.

    - [Official site](https://git-scm.com/){:target="_blank"}
    - [GitHub CLI docs](https://cli.github.com/){:target="_blank"}
    - [Getting started with Git](https://git-scm.com/doc){:target="_blank"}
    - [GitHub CLI manual](https://cli.github.com/manual/){:target="_blank"}

1. Create a GitHub account at [github.com](https://github.com/){:target="_blank"} if you don't already have one.

=== "macOS"

    2. Install Git and GitHub CLI:

        ```bash
        brew install git gh
        ```

    3. Authenticate GitHub CLI:

        ```bash
        gh auth login
        ```

=== "Windows"

    2. Install Git and GitHub CLI:

        ```powershell
        choco install git gh
        ```

    3. Authenticate GitHub CLI:

        ```powershell
        gh auth login
        ```

#### Validation

- [ ] Run `git --version` to verify Git is installed.
- [ ] Run `gh auth status` to confirm GitHub CLI is authenticated.

> 🏆 Achievement Unlocked: GitHub connected!

### 2.2 Cloudflare Wrangler

!!! info "Cloudflare Wrangler"
    Wrangler is the CLI (Command Line Interface) tool for managing Cloudflare services, including Workers and DNS.

    - [Official site](https://developers.cloudflare.com/workers/wrangler/){:target="_blank"}
    - [Docs](https://developers.cloudflare.com/workers/wrangler/commands/){:target="_blank"}

=== "macOS"

    1. Install Node.js (if not already installed):

        ```bash
        brew install node
        ```

    2. Install Wrangler via npm:

        ```bash
        npm install -g wrangler
        ```

    3. Authenticate Wrangler:

        ```bash
        wrangler login
        ```

=== "Windows"

    1. Install Node.js (if not already installed):

        ```powershell
        choco install nodejs
        ```

    2. Install Wrangler via npm:

        ```powershell
        npm install -g wrangler
        ```

    3. Authenticate Wrangler:

        ```powershell
        wrangler login
        ```

#### Validation

- [ ] Run `wrangler --version` to verify installation.
- [ ] Run `wrangler whoami` to confirm authentication.

> 🏆 Achievement Unlocked: Cloudflare wrangler ready!

### 2.3 Docker Desktop

!!! info "Docker Desktop"
    Docker runs applications in containers. Docker Desktop provides the local engine and UX (User Experience) we will use to run services during the labs.

    - [Official site](https://www.docker.com/products/docker-desktop){:target="_blank"}
    - [Docs](https://docs.docker.com/get-started/){:target="_blank"}
    - [Training](https://www.docker.com/101-tutorial){:target="_blank"}

=== "macOS"

    1. Install via Homebrew Cask:

        ```bash
        brew install --cask docker
        ```
    2. Validate:

        ```bash
        docker version
        docker run hello-world
        ```
     Note: Do not install the separate `docker` formula. Docker Desktop includes the CLI.

=== "Windows"

    1. Install Docker Desktop. Enable Kubernetes only if needed later.

        ```powershell
        choco install docker-desktop
        ```
     Note: Do not install the separate `docker` package. Docker Desktop includes the CLI.

    2. Validate:

        ```powershell
        docker version
        docker run hello-world
        ```

#### Validation

- [ ] Run `docker version` to check Docker installation.
- [ ] Run `docker run hello-world` to verify container runtime.

> 🏆 Achievement Unlocked: Docker containerized!

### 2.4 Terraform Install and Validation

!!! info "Terraform"
    Terraform defines infrastructure as code (IaC) and provisions cloud or on‑prem resources declaratively.

    - [Official site](https://www.terraform.io/){:target="_blank"}
    - [Docs](https://developer.hashicorp.com/terraform/docs){:target="_blank"}
    - [Getting started](https://developer.hashicorp.com/terraform/tutorials){:target="_blank"}

=== "macOS"

    1. Install Terraform:

        ```bash
        brew tap hashicorp/tap
        brew install hashicorp/tap/terraform
        ```

    2. Validate:

        ```bash
        terraform -version
        ```

=== "Windows"

    1. Install Terraform:

        ```powershell
        choco install terraform
        ```

    2. Validate:

        ```powershell
        terraform -version
        ```

#### Validation

- [ ] Run `terraform -version` to confirm installation.

> 🏆 Achievement Unlocked: Terraform deployed!

### 2.5 Vault and Consul CLI

!!! info "HashiCorp Vault and Consul"
    Vault manages secrets and protects sensitive data. Consul provides service discovery and key‑value storage. Both CLIs (Command Line Interfaces) are needed for later chapters.

    - [Vault site](https://www.vaultproject.io/){:target="_blank"}
    - [Consul site](https://www.consul.io/){:target="_blank"}
    - [Vault CLI docs](https://developer.hashicorp.com/vault/docs/commands){:target="_blank"}
    - [Consul CLI docs](https://developer.hashicorp.com/consul/docs/commands){:target="_blank"}

=== "macOS"

    1. Install Vault and Consul:

        ```bash
        brew tap hashicorp/tap
        brew install hashicorp/tap/vault hashicorp/tap/consul
        ```

    2. Validate:

        ```bash
        vault --version
        consul --version
        ```

=== "Windows"

    1. Install Vault and Consul:

        ```powershell
        choco install vault consul
        ```

    2. Validate:

        ```powershell
        vault --version
        consul --version
        ```

#### Validation

- [ ] Run `vault --version` to verify Vault CLI.
- [ ] Run `consul --version` to verify Consul CLI.

> 🏆 Achievement Unlocked: Secrets and service mesh mastered!

### 2.6 Ansible Install and Validation (optional for Windows)

!!! info "Ansible"
    Ansible automates configuration management and orchestration for your homelab.

    - [Official site](https://www.ansible.com/){:target="_blank"}
    - [Docs](https://docs.ansible.com/ansible/latest/index.html){:target="_blank"}
    - [Getting started](https://docs.ansible.com/ansible/latest/user_guide/intro_getting_started.html){:target="_blank"}

=== "macOS"

    1. Install Ansible:

        ```bash
        brew install ansible
        ```

    2. Validate:

        ```bash
        ansible --version
        ```

=== "Windows"

    !!! tip "Optional on Windows"
        On Windows, install Ansible via WSL (Windows Subsystem for Linux) or another supported method. Skip if not needed now.

    1. Validate (if installed):

        ```powershell
        ansible --version
        ```

#### Validation

- [ ] Run `ansible --version` to verify installation (if installed).

> 🏆 Achievement Unlocked: Automation activated!

### 2.7 Visual Studio Code

!!! info "Visual Studio Code (VS Code)"
    Visual Studio Code (VS Code) is a flexible editor with rich extensions useful for this lab.

    - [Download](https://code.visualstudio.com/){:target="_blank"}

=== "macOS"

    1. Install Visual Studio Code via Homebrew Cask:

        ```bash
        brew install --cask visual-studio-code
        ```

    2. Install recommended extensions:

        - hashicorp.terraform
        - redhat.ansible
        - ms-azuretools.vscode-docker
        - redhat.vscode-yaml
        - github.vscode-github-actions
        - ms-vscode-remote.remote-containers
        - gruntfuggly.todo-tree
        - esbenp.prettier-vscode
        - yzhang.markdown-all-in-one

        ```bash
        code --install-extension hashicorp.terraform
        code --install-extension redhat.ansible
        code --install-extension ms-azuretools.vscode-docker
        code --install-extension redhat.vscode-yaml
        code --install-extension github.vscode-github-actions
        code --install-extension ms-vscode-remote.remote-containers
        code --install-extension gruntfuggly.todo-tree
        code --install-extension esbenp.prettier-vscode
        code --install-extension yzhang.markdown-all-in-one
        ```

    3. (Optional) Apply quality‑of‑life settings via CLI by overwriting settings.json:

        ```bash
        cat <<'EOF' > ~/Library/Application\ Support/Code/User/settings.json
        {
          "editor.formatOnSave": true,
          "files.trimTrailingWhitespace": true,
          "editor.rulers": [100],
          "editor.tabSize": 2,
          "editor.insertSpaces": true,
          "editor.detectIndentation": false,
          "files.autoSave": "afterDelay",
          "files.autoSaveDelay": 1000,
          "[terraform]": { "editor.defaultFormatter": "hashicorp.terraform" },
          "terraform.languageServer": { "enabled": true },
          "makefile.configureOnOpen": true
        }
        EOF
        ```

=== "Windows"

    1. Install Visual Studio Code via Chocolatey:

        ```powershell
        choco install vscode
        ```

    2. Install recommended extensions:

        - hashicorp.terraform
        - redhat.ansible
        - ms-azuretools.vscode-docker
        - redhat.vscode-yaml
        - github.vscode-github-actions
        - ms-vscode-remote.remote-containers
        - ms-vscode.powershell
        - gruntfuggly.todo-tree
        - esbenp.prettier-vscode
        - yzhang.markdown-all-in-one

        ```powershell
        code --install-extension hashicorp.terraform
        code --install-extension redhat.ansible
        code --install-extension ms-azuretools.vscode-docker
        code --install-extension redhat.vscode-yaml
        code --install-extension github.vscode-github-actions
        code --install-extension ms-vscode-remote.remote-containers
        code --install-extension ms-vscode.powershell
        code --install-extension gruntfuggly.todo-tree
        code --install-extension esbenp.prettier-vscode
        code --install-extension yzhang.markdown-all-in-one
        ```

    3. (Optional) Apply quality‑of‑life settings via CLI by overwriting settings.json:

        ```powershell
        Set-Content "$env:APPDATA\Code\User\settings.json" @'
        {
          "editor.formatOnSave": true,
          "files.trimTrailingWhitespace": true,
          "editor.rulers": [100],
          "editor.tabSize": 2,
          "editor.insertSpaces": true,
          "editor.detectIndentation": false,
          "files.autoSave": "afterDelay",
          "files.autoSaveDelay": 1000,
          "[terraform]": { "editor.defaultFormatter": "hashicorp.terraform" },
          "terraform.languageServer": { "enabled": true },
          "makefile.configureOnOpen": true
        }
        '@
        ```

#### Validation

- [ ] Open VS Code and verify recommended extensions are installed.

> 🏆 Achievement Unlocked: Code editor powered up!

## Exit Criteria

- [ ] Git and GitHub CLI are installed and authenticated
- [ ] Wrangler is installed and authenticated
- [ ] curl is installed and validated (Windows only, macOS already includes curl)
- [ ] Docker Desktop is installed and running containers successfully
- [ ] Terraform is installed and validated
- [ ] Ansible is installed and validated (if applicable)
- [ ] Vault CLI is installed and validated
- [ ] Consul CLI is installed and validated

> 🎉 Chapter Complete! You’ve earned up to 70 XP (like Whose Line, the points are made up but the fun is real). Onward to the next adventure!
