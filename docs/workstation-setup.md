---
icon: material/laptop
---
# Workstation Setup

**Goal:** Install all necessary tools and prerequisites on your workstation or laptop, including core development tools, HashiCorp stack, and virtualization software, to enable local development and cloud control plane management.

## Prerequisites

!!! note "Virtualization must be enabled"
    If you will run local VMs (VirtualBox/Vagrant), ensure CPU virtualization is enabled in firmware:
    
    - Intel VT‑x or AMD‑V enabled in BIOS/UEFI (Windows/Linux hosts).
    - On macOS Apple Silicon, VirtualBox support is limited; prefer UTM/VMware Fusion Tech Preview or use cloud providers.

=== "macOS"

    Most tools are installed via Homebrew. See each section for details.

=== "Windows"

    Chocolatey is required for package installs. See <https://chocolatey.org/install> for instructions.

=== "Linux"

    Most distros ship with native package managers (apt, dnf, pacman). No extra prerequisite is needed.

---

## <img src="https://raw.githubusercontent.com/github/explore/main/topics/git/git.png" alt="Git logo" width="20"/> Git
> **Git** tracks source changes and enables collaboration.  
> <https://git-scm.com/>  
> Training: <https://git-scm.com/doc>

=== "macOS"

    ```bash
    brew install git
    ```

    !!! tip "Post‑install verification"
        ```bash
        git --version
        ```

=== "Windows"

    Download from <https://git-scm.com/download/win> or use Chocolatey:

    ```powershell
    choco install git
    ```

    !!! tip "Post‑install verification"
        ```powershell
        git --version
        ```

=== "Linux"

    ```bash
    sudo apt update && sudo apt install -y git
    ```

    !!! tip "Post‑install verification"
        ```bash
        git --version
        ```

---

## <img src="https://cdn.simpleicons.org/github" alt="GitHub CLI logo" width="20"/> GitHub CLI
> **GitHub CLI** enables GitHub workflows from the command line.  
> <https://cli.github.com/>  
> Training: <https://docs.github.com/en/get-started/using-git/about-git>

=== "macOS"

    ```bash
    brew install gh
    ```

    !!! tip "Post‑install verification"
        ```bash
        gh --version
        ```

=== "Windows"

    ```powershell
    choco install gh
    ```

    !!! tip "Post‑install verification"
        ```powershell
        gh --version
        ```

=== "Linux"

    See <https://cli.github.com/manual/installation> or on Ubuntu:

    ```bash
    sudo apt update && sudo apt install -y gh
    ```

    !!! tip "Post‑install verification"
        ```bash
        gh --version
        ```

---

## <img src="https://cdn.simpleicons.org/github" alt="GitHub Desktop logo" width="20"/> GitHub Desktop
> **GitHub Desktop** provides a GUI for Git/GitHub workflows.  
> <https://desktop.github.com/>  
> Training: <https://docs.github.com/en/desktop>

=== "macOS"

    Download the `.dmg` from <https://desktop.github.com/> and install.

    !!! tip "Post‑install verification"
        Launch the app and sign in to GitHub.

=== "Windows"

    Download and run the installer from <https://desktop.github.com/>.

    !!! tip "Post‑install verification"
        Launch the app and sign in to GitHub.

=== "Linux"

    Unofficial builds: <https://github.com/shiftkey/desktop> or use **GitHub CLI**: <https://cli.github.com/>.

    !!! tip "Post‑install verification"
        Launch the app and sign in to GitHub.

---

## <img src="https://raw.githubusercontent.com/github/explore/main/topics/visual-studio-code/visual-studio-code.png" alt="VS Code logo" width="20"/> VS Code
> **Visual Studio Code** is a lightweight, extensible editor.  
> <https://code.visualstudio.com/>  
> Training: <https://code.visualstudio.com/docs>

=== "macOS"

    ```bash
    brew install --cask visual-studio-code
    ```

    !!! tip "Post‑install verification"
        ```bash
        code --version
        ```

=== "Windows"

    Download from <https://code.visualstudio.com/Download> or via Chocolatey:

    ```powershell
    choco install vscode
    ```

    !!! tip "Post‑install verification"
        ```powershell
        code --version
        ```

=== "Linux"

    See <https://code.visualstudio.com/docs/setup/linux> or on Ubuntu:

    ```bash
    sudo apt update && sudo apt install -y code
    ```

    !!! tip "Post‑install verification"
        ```bash
        code --version
        ```

---

## <img src="https://raw.githubusercontent.com/github/explore/main/topics/docker/docker.png" alt="Docker logo" width="20"/> Docker Desktop
> **Docker Desktop** runs and manages containers locally.  
> Docs: <https://www.docker.com/products/docker-desktop/>  
> Training: <https://training.docker.com/>

=== "macOS"

    Download from Docker or install via Homebrew cask.

    ```bash
    brew install --cask docker
    ```

    !!! tip "Post‑install verification"
        ```bash
        docker version
        ```
        ```bash
        docker run hello-world
        ```

=== "Windows"

    Download from Docker or install with Chocolatey.

    ```powershell
    choco install docker-desktop
    ```

    !!! tip "Post‑install verification"
        ```powershell
        docker version
        ```
        ```powershell
        docker run hello-world
        ```

=== "Linux"

    Install **Docker Engine** for your distro: <https://docs.docker.com/engine/install/>

    !!! tip "Post‑install verification"
        ```bash
        docker version
        ```
        ```bash
        docker run hello-world
        ```

---

## <img src="https://raw.githubusercontent.com/github/explore/main/topics/terraform/terraform.png" alt="Terraform logo" width="20"/> HashiCorp Terraform
> **Terraform** provisions cloud and on‑prem resources via code.  
> <https://www.terraform.io/>  
> Training: <https://learn.hashicorp.com/terraform>

=== "macOS"

    ```bash
    brew tap hashicorp/tap
    brew install hashicorp/tap/terraform
    ```

    !!! tip "Post‑install verification"
        ```bash
        terraform -help
        ```

=== "Windows"

    ```powershell
    choco install terraform
    ```

    !!! tip "Post‑install verification"
        ```powershell
        terraform -help
        ```

=== "Linux"

    ```bash
    curl -fsSL https://apt.releases.hashicorp.com/gpg | sudo gpg --dearmor -o /usr/share/keyrings/hashicorp-archive-keyring.gpg
    echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com $(lsb_release -cs) main" | sudo tee /etc/apt/sources.list.d/hashicorp.list
    sudo apt update && sudo apt install -y terraform
    ```

    !!! tip "Post‑install verification"
        ```bash
        terraform -help
        ```

---

## <img src="https://cdn.simpleicons.org/vault" alt="Vault logo" width="20"/> HashiCorp Vault
> **Vault** secures and brokers secrets for automation and apps.  
> <https://www.vaultproject.io/>  
> Training: <https://learn.hashicorp.com/vault>

=== "macOS"

    ```bash
    brew tap hashicorp/tap
    brew install hashicorp/tap/vault
    ```

    !!! tip "Post‑install verification"
        ```bash
        vault -help
        ```

=== "Windows"

    ```powershell
    choco install vault
    ```

    !!! tip "Post‑install verification"
        ```powershell
        vault -help
        ```

=== "Linux"

    ```bash
    curl -fsSL https://apt.releases.hashicorp.com/gpg | sudo gpg --dearmor -o /usr/share/keyrings/hashicorp-archive-keyring.gpg
    echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com $(lsb_release -cs) main" | sudo tee /etc/apt/sources.list.d/hashicorp.list
    sudo apt update && sudo apt install -y vault
    ```

    !!! tip "Post‑install verification"
        ```bash
        vault -help
        ```

---

## <img src="https://cdn.simpleicons.org/packer" alt="Packer logo" width="20"/> HashiCorp Packer
> **Packer** builds golden images for many platforms.  
> <https://www.packer.io/>  
> Training: <https://learn.hashicorp.com/packer>

=== "macOS"

    ```bash
    brew tap hashicorp/tap
    brew install hashicorp/tap/packer
    ```

    !!! tip "Post‑install verification"
        ```bash
        packer -help
        ```

=== "Windows"

    ```powershell
    choco install packer
    ```

    !!! tip "Post‑install verification"
        ```powershell
        packer -help
        ```

=== "Linux"

    ```bash
    curl -fsSL https://apt.releases.hashicorp.com/gpg | sudo gpg --dearmor -o /usr/share/keyrings/hashicorp-archive-keyring.gpg
    echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com $(lsb_release -cs) main" | sudo tee /etc/apt/sources.list.d/hashicorp.list
    sudo apt update && sudo apt install -y packer
    ```

    !!! tip "Post‑install verification"
        ```bash
        packer -help
        ```

---

## <img src="https://cdn.simpleicons.org/ansible" alt="Ansible logo" width="20"/> Ansible
> **Ansible** automates configuration and application deployment.  
> <https://www.ansible.com/>  
> Training: <https://docs.ansible.com/ansible/latest/user_guide/index.html>

=== "macOS"

    ```bash
    brew install ansible
    ```

    !!! tip "Post‑install verification"
        ```bash
        ansible --version
        ```

=== "Windows"

    Use **WSL** and follow Linux instructions inside WSL.

    !!! tip "Post‑install verification"
        ```powershell
        ansible --version
        ```

=== "Linux"

    ```bash
    sudo apt update && sudo apt install -y ansible
    ```

    !!! tip "Post‑install verification"
        ```bash
        ansible --version
        ```

---

## <img src="https://cdn.simpleicons.org/virtualbox" alt="VirtualBox logo" width="20"/> Oracle VirtualBox
> **VirtualBox** provides a local hypervisor used by Vagrant.  
> <https://www.virtualbox.org/>  
> Training: <https://www.virtualbox.org/manual/UserManual.html>

=== "macOS"

    **Apple Silicon**: VirtualBox support is experimental/limited. Prefer VMware Fusion Tech Preview, UTM, or run VMs in Proxmox/cloud.  
    Download from <https://www.virtualbox.org/wiki/Downloads> and install.

    !!! tip "Post‑install verification"
        ```bash
        VBoxManage --version
        ```

=== "Windows"

    ```powershell
    choco install virtualbox
    ```

    Ensure virtualization (Intel VT‑x/AMD‑V) is enabled in BIOS/UEFI.

    !!! tip "Post‑install verification"
        ```powershell
        VBoxManage --version
        ```

=== "Linux"

    ```bash
    sudo apt update && sudo apt install -y virtualbox
    ```

    Ensure virtualization (Intel VT‑x/AMD‑V) is enabled in BIOS/UEFI.

    !!! tip "Post‑install verification"
        ```bash
        VBoxManage --version
        ```

---

## <img src="https://cdn.simpleicons.org/vagrant" alt="Vagrant logo" width="20"/> HashiCorp Vagrant
> **Vagrant** manages reproducible VM environments.  
> <https://www.vagrantup.com/>  
> Training: <https://learn.hashicorp.com/vagrant>

=== "macOS"

    ```bash
    brew tap hashicorp/tap
    brew install hashicorp/tap/vagrant
    ```

    !!! tip "Post‑install verification"
        ```bash
        vagrant --version
        ```

=== "Windows"

    Download from <https://www.vagrantup.com/downloads> or install with Chocolatey:

    ```powershell
    choco install vagrant
    ```

    !!! tip "Post‑install verification"
        ```powershell
        vagrant --version
        ```

=== "Linux"

    ```bash
    curl -fsSL https://apt.releases.hashicorp.com/gpg | sudo gpg --dearmor -o /usr/share/keyrings/hashicorp-archive-keyring.gpg
    echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com $(lsb_release -cs) main" | sudo tee /etc/apt/sources.list.d/hashicorp.list
    sudo apt update && sudo apt install -y vagrant
    ```

    !!! tip "Post‑install verification"
        ```bash
        vagrant --version
        ```

---

## <img src="https://cdn.simpleicons.org/cloudflare" alt="Cloudflare logo" width="20"/> Cloudflare Wrangler
> **Wrangler** is a CLI tool for Cloudflare Workers deployment and management.  
> <https://developers.cloudflare.com/workers/cli-wrangler>  
> Training: <https://developers.cloudflare.com/workers/tutorials/>

=== "macOS"

    ```bash
    brew install wrangler
    ```

    !!! tip "Post‑install verification"
        ```bash
        wrangler --version
        ```

=== "Windows"

    Install via npm (Node.js required):

    ```powershell
    npm install -g @cloudflare/wrangler
    ```

    !!! tip "Post‑install verification"
        ```powershell
        wrangler --version
        ```

=== "Linux"

    Install via npm (Node.js required):

    ```bash
    npm install -g @cloudflare/wrangler
    ```

    !!! tip "Post‑install verification"
        ```bash
        wrangler --version
        ```

---

## ✅ Checkpoint: Verify Your Workstation Setup

Run these commands to confirm all tools are installed and accessible:

```bash
git --version
gh --version
code --version
docker version
terraform -help
vault -help
packer -help
ansible --version
VBoxManage --version
vagrant --version
wrangler --version
```

If each command prints a version or help output without error, your workstation is ready for homelab development.
