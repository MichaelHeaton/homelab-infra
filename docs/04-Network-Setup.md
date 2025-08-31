---
icon: material/lan
---
# Network Setup & Terraform Imports

## Overview
Define LAN/VLAN plan, assign CIDRs, configure router/switch, then import discovered resources into Terraform.

## Outcomes
- VLANs and CIDRs documented and provisioned.
- Router/firewall interfaces and DHCP scopes configured.
- Terraform state updated via `terraform import` for existing network objects.

## Entry Checks
- Router/firewall reachable via UI and SSH.
- Admin creds and backup exported.
- Terraform CLI installed and working.

## Labs
1. **Design the addressing plan**
   - Choose RFC1918 blocks and per‑VLAN CIDRs.
   - Reserve infra ranges for gateways, DHCP, DNS, and static hosts.
2. **Define VLANs and tagging**
   - Map names → IDs (e.g., `10-MGMT`, `20-SERVERS`, `30-IOT`, `40-GUEST`).
   - Document trunk and access ports on the switch.
3. **Configure router/firewall**
   - Create VLAN interfaces and gateways.
   - Enable DHCP per VLAN and set DNS.
   - Add basic inter‑VLAN rules and block guest→LAN.
4. **Export and import to Terraform**
   - Initialize provider for your platform.
   - Use `terraform import` to capture existing VLANs, interfaces, DHCP, and rules.
   - Run `terraform plan` to verify drift is zero.

## Validation
- [ ] Hosts on each VLAN receive DHCP and reach gateway.
- [ ] Expected inter‑VLAN access allowed; blocked paths denied.
- [ ] `terraform plan` shows no changes after import.

## Exit Criteria
- [ ] CIDR/VLAN matrix committed to the repo.
- [ ] Router/switch configs backed up.
- [ ] Terraform state contains imported network resources.

## Next
Proceed to NAS setup and Proxmox cluster.
