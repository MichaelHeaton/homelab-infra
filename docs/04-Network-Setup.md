---
icon: material/lan
---
# Network Setup & Terraform Imports

!!! info "Quick Overview"
    **What:** Build VLANs, firewall rules, and WiFi networks.
    **Why:** Networking is the backbone; it secures and connects everything.
    **Time:** 60–120 minutes.
    **XP:** Up to 80 points (like Whose Line, the points are made up but the fun is real).

## Entry Checks
- Router/firewall reachable via UI and SSH.
- Admin creds and backup exported.
- Terraform CLI (Command Line Interface) installed and working.

## Outcomes
- VLANs and CIDRs (Classless Inter-Domain Routing ranges) documented and provisioned.
- Router/firewall interfaces and DHCP scopes configured.
- Terraform state updated via `terraform import` for existing network objects.

This chapter turns your design into reality. With VLANs, tagging, firewall rules, and WiFi, you’ll wire your homelab’s nervous system.

## Labs

### 4.1 Design the addressing plan
- Choose RFC1918 blocks and per‑VLAN CIDRs.
- Reserve infra ranges for gateways, DHCP (Dynamic Host Configuration Protocol), DNS (Domain Name System), and static hosts.

#### VLAN Matrix Template

Fill out this matrix to document each VLAN with addressing and usage details.

| VLAN Name | VLAN ID | Subnet | Gateway | DHCP Range | Reserved Range | Purpose |
|-----------|---------|--------|---------|------------|---------------|---------|
| Default | 1 | 172.16.0.0/24 | 172.16.0.1 | 172.16.0.30 – 172.16.0.254 | 172.16.0.2 – 172.16.0.29 | Bootstrap, UniFi infra, temporary devices |
| Family | 5 | 172.16.5.0/24 | 172.16.5.1 | 172.16.5.30 – 172.16.5.254 | 172.16.5.2 – 172.16.5.5 | Household user devices |
| Production | 10 | 172.16.10.0/24 | 172.16.10.1 | 172.16.10.30 – 172.16.10.254 | 172.16.10.2 – 172.16.10.5 | Stable services and servers |
| Cluster | 12 | 172.16.12.0/24 | 172.16.12.1 | 172.16.12.30 – 172.16.12.254 | 172.16.12.2 – 172.16.12.9 | Hypervisors, K8s control plane |
| Mgmt-Admin | 15 | 172.16.15.0/24 | 172.16.15.1 | 172.16.15.30 – 172.16.15.254 | 172.16.15.2 – 172.16.15.5 | Admin workstations, jump hosts, management UIs (Proxmox, NAS (Network Attached Storage), etc.) |
| Lab | 20 | 172.16.20.0/24 | 172.16.20.1 | 172.16.20.30 – 172.16.20.254 | 172.16.20.2 – 172.16.20.5 | Experiments and short‑lived workloads |
| Storage | 30 | 172.16.30.0/24 | 172.16.30.1 | 172.16.30.30 – 172.16.30.254 | 172.16.30.2 – 172.16.30.5 | NAS, backup targets, storage services |
| DMZ | 40 | 172.16.40.0/24 | 172.16.40.1 | 172.16.40.30 – 172.16.40.254 | 172.16.40.2 – 172.16.40.5 | Public‑facing services (Demilitarized Zone) |
| Parking | 99 | 172.16.99.0/24 | 172.16.99.1 | — | 172.16.99.2 – 172.16.99.254 | Disabled/sinkhole ports with no DHCP |
| Guest | 101 | 172.16.101.0/24 | 172.16.101.1 | 172.16.101.30 – 172.16.101.254 | 172.16.101.2 – 172.16.101.5 | Guest WiFi and public wired ports with internet-only access |
| IoT | 200 | 172.16.200.0/23 | 172.16.200.1 | 172.16.200.30 – 172.16.201.254 | 172.16.200.2 – 172.16.200.29 | Smart home and camera devices (former VLAN 201 merged) (Internet of Things) |

#### Validation
- [ ] VLANs documented in matrix
🏆 Achievement Unlocked: Network blueprint drafted!

### 4.2 Define VLANs and tagging
- Map names → IDs (e.g., `10-MGMT`, `20-SERVERS`, `30-IOT`, `40-GUEST`).
- Document trunk and access ports on the switch.

#### Switch Port Mapping

Define access vs trunk ports to ensure consistent VLAN assignments across switches.

| Port    | Mode   | VLAN(s) | Usage                    |
|---------|--------|---------|--------------------------|
| Port 1  | Trunk  | All     | Uplink to router         |
| Port 2  | Access | 15      | Mgmt-Admin workstation   |
| Port 3  | Access | 30      | NAS/Storage              |
| Port 4  | Access | 200     | IoT device               |
| Port 5  | Access | 101     | Guest wired drop         |
| Port 6-24| Trunk | All     | APs (Access Points) / downstream switches|

Adjust per physical layout. Document every port to avoid misconfiguration and to simplify Terraform imports.

#### Validation
- [ ] Switch ports mapped and documented
🏆 Achievement Unlocked: Ports aligned!

### 4.3 Configure router/firewall
- Create VLAN interfaces and gateways.
- Enable DHCP per VLAN and set DNS (DNS at this stage is UniFi only; other DNS services are integrated later).
- Add basic inter‑VLAN rules and block guest→LAN.

#### Validation
- [ ] VLAN interfaces created
- [ ] DHCP enabled per VLAN
- [ ] Basic rules applied
🏆 Achievement Unlocked: Firewall foundations laid!

### 4.4 Export and import to Terraform
- Initialize provider for your platform.
- Use `terraform import` to capture existing VLANs, interfaces, DHCP, and rules.
- Include UniFi group imports as well.
- Run `terraform plan` to verify drift is zero.

#### Terraform Import Matrix

Map UniFi objects to Terraform resources for reproducible state.

| Object        | Example ID           | Terraform Resource       |
|---------------|----------------------|-------------------------|
| VLAN          | vlan_200             | unifi_network           |
| SSID          | ssid_iot_modern      | unifi_wireless_network  |
| Firewall Rule | rule_guest_to_lan_block | unifi_firewall_rule     |
| Group         | group_admins         | unifi_user_group        |

#### Validation
- [ ] Terraform imports succeed
- [ ] terraform plan shows no drift
🏆 Achievement Unlocked: State captured!

### 4.5 Configure WiFi Networks
- Create SSIDs (Service Set Identifiers) mapped to VLANs (Home/Family, Guest, IoT‑Legacy, IoT‑Modern).
- Apply security settings.
- Assign VLAN IDs.
- Verify WiFi clients get correct IPs.

#### Target SSIDs and VLAN mappings (end state)

| SSID | VLAN | Bands | Security | Client Isolation | Notes |
|------|------|-------|----------|------------------|-------|
| Home | Family (5) | 2.4 + 5 GHz | WPA2/WPA3 Transition | Off | Primary household devices |
| Guest | Guest (101) | 2.4 + 5 GHz | WPA2/WPA3 Transition | On | Internet-only, no LAN access |
| IoT‑Legacy | IoT (200) /23 | 2.4 GHz | WPA2‑PSK | On | Legacy smart home and cameras; widest compatibility |
| IoT‑Modern | IoT (200) /23 | 5 GHz | WPA3 or WPA3‑Transition | On | Newer IoT; easier to identify devices worth upgrading |

> **Note:**
> - UniFi SSID count kept minimal to meet per-AP limits and reduce airtime beacons.
> - Legacy or migrating devices can temporarily use a hidden SSID mapped to VLAN 200; remove when stable.
> - Use distinct PSKs for Legacy vs Modern to simplify device audits and planned upgrades.

#### Notes on UniFi SSID limits and design
Keep SSID count minimal to meet per-AP limits and reduce beacon airtime. Use two IoT SSIDs split by band on the single IoT VLAN (200 /23) to maximize compatibility while avoiding extra VLANs.

#### Best Practices
- Use 2.4 GHz band for IoT and Camera devices due to better range and compatibility.
- Use dual-band (2.4 GHz and 5 GHz) SSIDs for Family and Guest networks to optimize performance and device connectivity.
- Place management SSIDs and VLAN 15 on 5 GHz only, reduce 2.4 GHz exposure.
- Periodically audit DHCP leases and static assignments to avoid scope exhaustion.

#### Firewall Rules (Desired State)
- Block Guest (101) to LAN (all other VLANs) except Internet.
- Block IoT-Legacy/Modern (200) to LAN except allowed destinations (NVR, Home Assistant, etc.).
- Allow Mgmt-Admin (15) full access to all VLANs.
- Restrict DMZ (40) to Internet inbound/outbound only; no lateral movement.
- Log and alert on denied inter-VLAN traffic.

#### Moving a client between VLANs in UniFi UI for testing
1. Log in to the UniFi Controller UI.
2. Navigate to the Devices section and select the client device.
3. Under the client’s settings, locate the network or VLAN assignment.
4. Change the VLAN or network group to the desired VLAN for testing.
5. Apply changes and verify the client obtains an IP address in the new VLAN and has appropriate network access.

#### Validation
- [ ] SSIDs created
- [ ] Devices receive correct VLAN IPs
- [ ] Isolation verified
🏆 Achievement Unlocked: WiFi worlds connected!

## Exit Criteria
- [ ] CIDR/VLAN matrix committed to the repo.
- [ ] Router/switch configs backed up.
- [ ] Terraform state contains imported network resources.

> 🎉 Chapter Complete! You’ve earned up to 80 XP (like Whose Line, the points are made up but the fun is real). Networking backbone established!
