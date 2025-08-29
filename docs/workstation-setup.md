---
icon: material/laptop
---

# Workstation Setup

## Overview

This chapter covers installing the core tools needed to build the lab: Git, GitHub CLI, Docker, Terraform, and Ansible.

## Outcomes

- Install and configure Git and GitHub CLI
- Install Docker Desktop and verify installation
- Install Terraform and validate setup
- (Optional) Install Ansible and validate setup on supported platforms

## Entry Checks

- macOS or Windows with admin rights
- Git and GitHub account
- Docker Desktop available

## Labs

### Preparing Package Managers

=== "macOS"

    1. Install Homebrew (if not already installed):

        ```bash
        /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
        ```

=== "Windows"

    1. Install Chocolatey (if not already installed):

        ```powershell
        Set-ExecutionPolicy Bypass -Scope Process -Force; `
        [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072; `
        iex ((New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1'))
        ```

### Lab 1: Git and GitHub CLI

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

### Lab 2: Docker Desktop

!!! info "Docker Desktop"
    Docker runs applications in containers. Docker Desktop provides the local engine and UX we will use to run services during the labs.

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

### Lab 3: Terraform Install and Validation

!!! info "Terraform"
    Terraform defines infrastructure as code and provisions cloud or on‑prem resources declaratively.

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

### Lab 4: Ansible Install and Validation (optional for Windows)

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
        On Windows, install Ansible via WSL or another supported method. Skip if not needed now.

    1. Validate (if installed):

        ```powershell
        ansible --version
        ```

### Lab 5: Visual Studio Code

!!! info "Visual Studio Code (VS Code)"
    Visual Studio Code is a flexible editor with rich extensions useful for this lab.

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

## Validation

- [ ] git --version and gh auth status show logged in
- [ ] Docker pulls and runs hello-world container
- [ ] Terraform version command outputs installed version
- [ ] Ansible version command outputs installed version (if installed)

## Exit Criteria

- [ ] Git and GitHub CLI are installed and authenticated
- [ ] Docker Desktop is installed and running containers successfully
- [ ] Terraform is installed and validated
- [ ] Ansible is installed and validated (if applicable)

Next → [Cloud Accounts & Foundations](cloud-control-plane-setup.md)
