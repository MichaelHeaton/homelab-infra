---
icon: material/server
---
# Proxmox Cluster Setup

!!! info "Quick Overview"
    **What:** Prepare and build a 3-node Proxmox cluster with storage and networking.
    **Why:** Clustering unlocks High Availability (HA), shared storage, and scaling for your homelab.
    **Time:** 90–150 minutes.
    **XP:** Up to 100 points (like Whose Line, the points are made up but the fun is real).

## Outcomes
- Proxmox installed and nodes joined into a cluster
- Cluster storage configured and accessible
- Networks segmented (management, storage, workloads)
- Baseline Virtual Machines (VMs) created for Consul + Vault


Now it’s time to link your nodes into a unified cluster. Proper Network Interface Card (NIC) setup, storage connections, and VM baselines will give you a resilient backbone for your homelab.

!!! warning "Before forming the cluster"
    * Put the **cluster (ring0) IP first** in `/etc/hosts` for each node's canonical name (e.g., `GPU01`).
    * Ensure **management IP** is a separate alias/line (e.g., `GPU01-mgmt`).
    * Make sure **time is in sync** across all nodes (see *Time Sync* below).
    * Verify **VLAN reachability** for mgmt (15), cluster (12), and storage (30).



## Entry Checks
- Hardware nodes available and reachable on the network
- Admin workstation can reach Proxmox web User Interface (UI)
- Virtual Local Area Networks (VLANs) planned and documented
- HA watchdog playbook ready to run on all nodes

## Cluster Decisions Pending

Track and lock decisions that affect automation and later migrations.

- [x] **Auth model (now → later):** start with `root@pam` + API tokens; migrate to SSO/LDAP later.
  _Impact:_ inventories use pam credentials initially; plan a credential rotation runbook.

- [x] **TLS certificates:** start with self-signed on all nodes; migrate to Let's Encrypt (DNS-01) later.
  _Impact:_ Terraform/Ansible set `validate_certs: false` initially; flip to true after cert rollout.

- [x] **Template strategy:** standardize template IDs **9000–9099** and names like `tmpl-ubuntu-24.04.3-amd64`.
  _Impact:_ Terraform references stable template IDs; CI can rebuild templates safely.

- [x] **PBS retention defaults:** daily **7**, weekly **4**, monthly **6**.
  _Note:_ Per-VM overrides allowed as services come online.

- [ ] **Monitoring stack host:** defer until cluster is live.
  _Plan:_ Deploy Prometheus + exporters after base cluster and PBS are running.

- [ ] **Fencing/HA watchdog:** verify watchdog support on GPU01, NUC01, NUC02; enable Proxmox HA stack.
  _Steps:_
    1) Check `dmesg | grep -i watchdog` and `lsmod | grep -i watchdog`
    2) If absent, enable `softdog` temporarily or vendor-specific module if available
    3) Confirm `pve-ha-lrm` and `pve-ha-crm` services are active
    4) Document final fencing method

## Time Sync

### Time Sync Configuration

Accurate and consistent time is critical for Proxmox clustering, Corosync quorum, PBS, and logs.

**Plan: Hybrid NTP setup**
- **Primary:** `132.163.96.1` and `129.6.15.28` (NIST official servers).
- **Secondary (LAN fallback):** NAS01 at `172.16.0.5` with NTP Service enabled in DSM (Control Panel → Regional Options → Time).

**Implementation**
1. On NAS01, enable the built-in NTP Service.
2. On all Proxmox nodes (GPU01, NUC01, NUC02), configure NTP servers:
   - `132.163.96.1`
   - `129.6.15.28`
   - `172.16.0.5`
   **Note (Proxmox specifics):** On Proxmox, you might not see a `systemd-timesyncd.service` unit even though `timedatectl` reports NTP as *active*. Configure servers and check sync via:
   ```bash
   timedatectl set-ntp true
   timedatectl show-timesync --all | sed -n '1,80p'
   timedatectl status
   date
   ```
   If you prefer a full NTP daemon, install and configure `chrony` instead of relying on the minimal timesync stub.
3. Verify with `timedatectl show-timesync --all` that both sources are listed and sync is stable.
4. PBS VM will inherit this config from its Proxmox host.
5. Optional: monitor NTP drift with Prometheus node_exporter.

#### Validation
- [ ] NTP service enabled on NAS01
- [ ] All cluster nodes use both 132.163.96.1, 129.6.15.28, and NAS01 as time sources
🏆 Achievement Unlocked: Cluster clocks in sync!

## Labs

### 6.1 NIC Setup for single vs multiple Network Interface Cards (NICs)
Explain benefits and that Network Interface Cards (NICs) should be configured before cluster creation.

#### Validation
- [ ] Network Interface Cards (NICs) configured before cluster join
🏆 Achievement Unlocked: Network interfaces ready!

### 6.1b Validate VLAN reachability

Before forming the cluster, verify that all VLANs are properly configured and reachable from each node.

#### Steps
1. From GPU01, NUC01, and NUC02:
   ```bash
   ping 172.16.15.1     # VLAN 15 gateway (Mgmt)
   ping 172.16.12.1     # VLAN 12 gateway (Cluster/Corosync, if routed)
   ping 172.16.30.5     # NAS01 storage NIC
   ping 172.16.30.4     # NAS02 storage NIC
   ```
2. Check routing tables on each node (`ip route`) to confirm correct gateways.
3. Verify VLAN tagging on switch ports for each server NIC.
4. Adjust Proxmox network config (`/etc/network/interfaces`) if rebuild resets them.

#### Validation
- [ ] GPU01, NUC01, and NUC02 can reach VLAN 15 (Mgmt)
- [ ] GPU01 can reach VLAN 12 (Cluster) and VLAN 30 (Storage)
- [ ] NUC01 and NUC02 can reach VLAN 30 if required for storage

🏆 Achievement Unlocked: VLANs alive and reachable!

### 6.1c Hostname & `/etc/hosts` requirements (critical)

Corosync will bind to the address that your node's **canonical hostname** resolves to. Ensure the cluster IP (VLAN 12) is first for the node's primary name, and keep management/storage on separate aliases.

**Example `/etc/hosts` on GPU01**
```text
127.0.0.1       localhost
::1             localhost

# PVE node – put CLUSTER IP first
172.16.12.10    GPU01.SpecterRealm.com GPU01 gpu01.local gpu01
# Mgmt IP as separate alias
172.16.15.10    GPU01-mgmt.SpecterRealm.com GPU01-mgmt
# Storage IP as separate alias (optional)
172.16.30.10    GPU01-stor.SpecterRealm.com GPU01-stor
```

**Validation**
```bash
getent hosts $(hostname -s)     # should return the ring0/cluster IP first
hostname -I                      # verify the expected addresses exist
```

### 6.2 Create Proxmox cluster across NodeA, NodeB, NodeC

**Note:** GPU01 is the primary cluster manager and the first node in the cluster.

#### Understanding Quorum and QDevice
Quorum is the mechanism that ensures cluster consistency by requiring a majority of nodes to be online and communicating. To improve quorum reliability, a QDevice can be added as a tie-breaker. NAS01 can later serve as a QDevice host if a node is removed or travels, helping maintain cluster availability.

#### Validation
- [ ] Cluster created with quorum
🏆 Achievement Unlocked: Cluster formed!

#### 6.2a Join via CLI (fallback when API join errors with CSRF)
If the API-based join fails with `Permission denied - invalid csrf token`, use the SSH join workflow:

```bash
# On the joining node (e.g., NUC01/NUC02)
pvecm add GPU01.SpecterRealm.com --use_ssh         # or: pvecm add 172.16.12.10 --use_ssh
# If the node was partially joined before, add --force:
pvecm add 172.16.12.10 --use_ssh --force
```

**Why this helps:** `--use_ssh` bypasses the token-based API flow that can be impacted by name/TLS/CSRF issues and uses the Proxmox-maintained SSH path to copy the corosync auth key and generate certificates.

#### 6.2b Remove/re-add a stale node
If a node was joined with the wrong IP or failed mid-join, clean it up and rejoin:

```bash
# On the broken node (e.g., NUC02)
systemctl stop pve-cluster corosync
killall pmxcfs || true
rm -rf /etc/pve/corosync.conf
rm -rf /etc/corosync/* /var/lib/corosync/* /var/lib/pve-cluster/config.db*
systemctl start pve-cluster

# Re-add via SSH (forces overwrite of stale config)
pvecm add 172.16.12.10 --use_ssh --force
```

If the cluster itself lost quorum during cleanup, on the leader you can temporarily lower the expected votes to remove a dead node:
```bash
pvecm expected 1
pvecm delnode <NODENAME>
```

#### 6.2c Fixing wrong ring0 IP after cluster creation
If the leader formed the cluster using the **management IP** instead of the cluster IP:

1) Fix `/etc/hosts` on the leader so the **cluster IP is first** for the node’s canonical name (see 6.1c).
2) Recreate the cluster cleanly on the leader:
```bash
systemctl stop pve-cluster corosync
pmxcfs -l               # ensure it now resolves to the cluster IP
rm -f /etc/pve/corosync.conf
killall pmxcfs || true
systemctl start pve-cluster
pvecm create pve-cluster01
```
3) Join the remaining nodes with:
```bash
pvecm add 172.16.12.10 --use_ssh
```
4) Validate:
```bash
pvecm status
grep -E 'ring0_addr|name|cluster_name' /etc/pve/corosync.conf
```

### 6.3 Configure management VLAN and Access Control Lists (ACLs) (allow Jump Box, Continuous Integration (CI), admin)

**VLAN IDs:**
- VLAN 15: Management
- VLAN 12: Corosync/Cluster
- VLAN 30: Storage
- VLAN 10: Production workloads
- VLAN 20: Lab
- VLAN 40: Public Access
- VLAN 5: Family
- VLAN 200: IoT

#### Validation
- [ ] Management VLAN and Access Control Lists (ACLs) verified
🏆 Achievement Unlocked: Secure management lanes!

### 6.4 Connect to Network Attached Storage (NAS) via Network File System (NFS) and Internet Small Computer Systems Interface (iSCSI)

NAS01 provides NFS and iSCSI (primary datastore), while NAS02 provides NFS for media only. GPU01’s NVMe is used as a temporary datastore until NAS01 rebuild is complete.

#### Validation
- [ ] Network File System (NFS) mount verified
- [ ] Internet Small Computer Systems Interface (iSCSI) Logical Unit Number (LUN) attached
🏆 Achievement Unlocked: Shared storage online!

### 6.4b Validate NAS storage exports

Ensure NAS01 and NAS02 are correctly serving iSCSI and NFS before cluster integration.

#### Steps
1. From GPU01:
   ```bash
   nc -zv 172.16.30.5 3260     # iSCSI target on NAS01
   showmount -e 172.16.30.5   # NFS exports on NAS01
   showmount -e 172.16.30.4   # NFS exports on NAS02
   ```
2. Confirm expected exports:
   - NAS01: `vm-store`, `pbs-ds`, optional templates path
   - NAS02: `/Media` (RAID5 media share)
3. Document export names and paths for Ansible/Terraform use.

#### Validation
- [ ] NAS01 iSCSI target responds
- [ ] NAS01 NFS exports visible
- [ ] NAS02 NFS export `/Media` visible
🏆 Achievement Unlocked: Storage exports online!

### 6.5 Set up nightly snapshots to Proxmox Backup Server (PBS)/NAS (and offsite optional)

**PBS plan:** Run PBS as a **VM on GPU01**. Primary datastore on **NAS01 via iSCSI**. Network on **VLAN 15**. Retention: **daily 7, weekly 4, monthly 6**. Enable **prune** and **verify**.

**Implementation steps**
1. DNS: reserve `pbs01.<your-domain>` on VLAN 15. IP example: `172.16.15.50`.
2. NAS01 iSCSI: create target + LUN for `pbs-ds` on the storage pool you dedicate to backups.
3. Proxmox (GPU01): create `pbs01` VM, attach iSCSI LUN as a disk, format XFS or ext4 inside VM.
4. PBS setup: add datastore `pbs-ds`, set retention `7/4/6`, schedule **Verify** weekly, **Prune** weekly.
5. Proxmox jobs: create backup jobs for critical VMs/CTs to `pbs-ds`. Stagger schedules to avoid contention.
6. Optional offsite: later add cloud sync or a secondary NAS mirror for ransomware resilience.

**PBS hosting options**
| Option | Pros | Cons |
|---|---|---|
| **VM on Proxmox, datastore on NAS01 (iSCSI)** | Supported, simple upgrades, fast LAN | Consumes host CPU/RAM; depends on NAS01 |
| **Small dedicated box, datastore on NAS01** | Isolates PBS OS from hypervisors | Extra hardware; still one storage backend |
| **Docker on NAS01** | No extra hardware | **Unsupported** by Proxmox; feature breakage risk on upgrades |

#### Validation
- [ ] Backup snapshot completed
🏆 Achievement Unlocked: Snapshots scheduled!

### 6.6 Deploy 3-node Consul + Vault clusters spread across nodes

#### Validation
- [ ] Consul cluster booted
- [ ] Vault cluster sealed and reachable
🏆 Achievement Unlocked: Service backbone deployed!

### 6.7 Automation skeletons (copy/paste)

#### Ansible (cluster + storage) — minimal skeleton

`inventories/hosts.yml`
```yaml
all:
  vars:
    api_user: "root@pam"
    api_token_id: "{{ lookup('env','PVE_TOKEN_ID') }}"
    api_token_secret: "{{ lookup('env','PVE_TOKEN_SECRET') }}"
    validate_certs: false
    gpu01_mgmt_ip: "172.16.15.10"
  children:
    pve:
      hosts:
        gpu01: { ansible_host: "172.16.15.10", corosync_link0_ip: "172.16.12.10" }
        nuc01: { ansible_host: "172.16.15.11", corosync_link0_ip: "172.16.12.11" }
        nuc02: { ansible_host: "172.16.15.12", corosync_link0_ip: "172.16.12.12" }
```

`playbooks/10_cluster_bootstrap.yml`
```yaml
- hosts: gpu01
  gather_facts: false
  tasks:
    - name: Create cluster on GPU01
      community.proxmox.proxmox_cluster:
        state: present
        api_host: "{{ gpu01_mgmt_ip }}"
        api_user: "{{ api_user }}"
        api_token_id: "{{ api_token_id }}"
        api_token_secret: "{{ api_token_secret }}"
        cluster_name: "pve-cluster01"
        link0: "{{ hostvars['gpu01'].corosync_link0_ip }}"  # VLAN 12

- hosts: nuc01,nuc02
  gather_facts: false
  tasks:
    - name: Join cluster
      community.proxmox.proxmox_cluster:
        state: present
        api_host: "{{ inventory_hostname }}"
        api_user: "{{ api_user }}"
        api_token_id: "{{ api_token_id }}"
        api_token_secret: "{{ api_token_secret }}"
        master_ip: "{{ gpu01_mgmt_ip }}"
        link0: "{{ hostvars[inventory_hostname].corosync_link0_ip }}"  # VLAN 12
        # fingerprint: "<paste GPU01 API TLS fingerprint>"
```

`playbooks/20_storage.yml`
```yaml
- hosts: gpu01
  gather_facts: false
  tasks:
    - name: Add NAS01 iSCSI portal
      community.proxmox.proxmox_storage:
        api_host: "{{ hostvars['gpu01'].ansible_host }}"
        api_user: "{{ api_user }}"
        api_token_id: "{{ api_token_id }}"
        api_token_secret: "{{ api_token_secret }}"
        name: "nas01-iscsi"
        type: "iscsi"
        portal: "172.16.30.5"
        target: "iqn.2000-01.com.synology:nas01.pve"   # placeholder
        content: "images,rootdir"

    - name: Add LVM-Thin on iSCSI LUN (placeholder values)
      community.proxmox.proxmox_storage:
        api_host: "{{ hostvars['gpu01'].ansible_host }}"
        api_user: "{{ api_user }}"
        api_token_id: "{{ api_token_id }}"
        api_token_secret: "{{ api_token_secret }}"
        name: "vmstore"
        type: "lvmthin"
        vgname: "vg_vmstore"
        thinpool: "thin_vmstore"
        base: "/dev/mapper/<your-iscsi-lun-mapper>"
        content: "images,rootdir"

    - name: Add NFS (templates) from NAS01
      community.proxmox.proxmox_storage:
        api_host: "{{ hostvars['gpu01'].ansible_host }}"
        api_user: "{{ api_user }}"
        api_token_id: "{{ api_token_id }}"
        api_token_secret: "{{ api_token_secret }}"
        name: "nas01-nfs-templates"
        type: "nfs"
        server: "172.16.30.5"
        export: "/volumeX/pve-templates"   # placeholder path
        options: "vers=4.1"
        content: "iso,vztmpl,snippets"

    - name: Add NFS (media) from NAS02
      community.proxmox.proxmox_storage:
        api_host: "{{ hostvars['gpu01'].ansible_host }}"
        api_user: "{{ api_user }}"
        api_token_id: "{{ api_token_id }}"
        api_token_secret: "{{ api_token_secret }}"
        name: "nas02-media"
        type: "nfs"
        server: "172.16.30.4"
        export: "/mnt/media"   # placeholder path
        options: "vers=4.1"
        content: "backup"
```


`playbooks/15_enable_ha_watchdog.yml`
```yaml
- hosts: pve
  gather_facts: false
  become: true
  tasks:
    - name: Check for hardware watchdog device
      command: bash -lc "ls -1 /dev/watchdog* 2>/dev/null || true"
      register: wd_devices
      changed_when: false

    - name: Decide if softdog is required
      set_fact:
        need_softdog: "{{ wd_devices.stdout_lines | length == 0 }}"

    - name: Load softdog when no hardware watchdog is present
      when: need_softdog
      modprobe:
        name: softdog
        state: present

    - name: Persist softdog module across reboots
      when: need_softdog
      copy:
        dest: /etc/modules-load.d/watchdog.conf
        content: "softdog\n"
        owner: root
        group: root
        mode: '0644'

    - name: Enable and start Proxmox HA services
      systemd:
        name: "{{ item }}"
        enabled: true
        state: started
      loop:
        - pve-ha-lrm
        - pve-ha-crm

    - name: Assert HA services are healthy
      command: systemctl is-active {{ item }}
      register: ha_status
      changed_when: false
      failed_when: ha_status.rc != 0
      loop:
        - pve-ha-lrm
        - pve-ha-crm
```

#### Terraform (bpg/proxmox) — minimal skeleton

`terraform/providers.tf`
```hcl
terraform {
  required_providers {
    proxmox = { source = "bpg/proxmox", version = "~> 0.49" }
  }
}
provider "proxmox" {
  endpoint = "https://172.16.15.10:8006/"
  username = "root@pam"
  api_token = var.api_token
  insecure  = true
}
variable "api_token" { type = string }
```

`terraform/pbs01.tf` (upload PBS ISO to a datastore first)
```hcl
resource "proxmox_virtual_environment_vm" "pbs01" {
  name      = "pbs01"
  node_name = "GPU01"
  tags      = ["pbs"]
  cpu { cores = 2 }
  memory { dedicated = 4096 }

  disk {
    datastore_id = "vmstore"   # local or iSCSI-backed LVM-thin
    interface    = "scsi0"
    size         = 16
  }

  cdrom {
    file_id = "local:iso/proxmox-backup-server_*.iso"  # upload ISO
  }

  network_device {
    bridge  = "vmbr0"
    vlan_id = 15
  }

  initialization {
    user_account { username = "root" }
    ip_config {
      ipv4 { address = "172.16.15.50/24", gateway = "172.16.15.1" }
    }
    dns { servers = ["172.16.15.1"] }
  }
}
```

### 6.8 HA Fencing and Watchdog Validation

Proxmox HA relies on a watchdog device. If no hardware watchdog exists, enable the kernel **softdog** module.

#### Steps
1. **Detect watchdog (on each node)**
   ```bash
   ls -l /dev/watchdog* || true
   lsmod | grep -i watchdog || true
   dmesg | grep -i watchdog || true
   ```
2. **Enable softdog if no hardware watchdog is present**
   ```bash
   sudo modprobe softdog
   # make persistent across reboots
   echo softdog | sudo tee /etc/modules-load.d/watchdog.conf
   ```
3. **Start Proxmox HA services**
   ```bash
   sudo systemctl enable --now pve-ha-lrm pve-ha-crm
   sudo systemctl status pve-ha-lrm pve-ha-crm --no-pager
   ```
   > If `pve-ha-lrm`/`pve-ha-crm` previously logged “unable to write lrm status file” while the cluster filesystem was down, those errors should clear once quorum and `/etc/pve` are healthy again.
4. **Confirm watchdog is active in HA logs**
   ```bash
   journalctl -u pve-ha-lrm --since "5 min ago" | grep -i watchdog || true
   ```
5. **Optional: quick HA group smoke test**
   ```bash
   # create an HA group preferring GPU01, then NUC01, then NUC02
   ha-manager group add core pref=GPU01,Nuc01,Nuc02
   # add a non-critical test VM to HA (replace 101 with a test VMID)
   ha-manager add vm:101 --group core --state started
   ha-manager status
   ```
   _Note:_ Do not simulate failures yet. This is a non-disruptive verification only.

   **Automation:** You can run `ansible-playbook playbooks/15_enable_ha_watchdog.yml` to perform steps 2–3 on all nodes.

#### Validation
- [ ] `/dev/watchdog` exists on all nodes
- [ ] `softdog` loaded where no hardware watchdog is available
- [ ] `pve-ha-lrm` and `pve-ha-crm` are active
- [ ] `ha-manager status` returns without errors
- [ ] Ansible playbook `playbooks/15_enable_ha_watchdog.yml` executed successfully on all nodes

#### Fencing approaches — quick comparison
| Approach | Pros | Cons |
|---|---|---|
| **Hardware watchdog** (board/CPU vendor) | Fast, reliable fencing; minimal CPU | May not exist on NUCs; driver quirks |
| **softdog kernel module** | Universal, simple to enable | Software-based; lower assurance than hardware |
| **No watchdog (not recommended)** | Zero setup | HA cannot fence, risk of split-brain; HA disabled |
