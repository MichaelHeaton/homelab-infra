---
icon: material/memory
---
# Hardware

## Overview

This chapter guides you through choosing and preparing the hardware needed for your homelab environment. It covers the essential components including your workstation, Proxmox Nodes, NAS/Storage solutions, networking equipment, domain name setup, public IP considerations, and power management. By understanding these requirements, you will be able to select appropriate hardware to build a reliable and scalable homelab.

## Outcomes

By the end of this chapter, you will be able to:

- Determine the hardware requirements for your workstation.
- Understand the specifications needed for Proxmox Nodes.
- Identify suitable NAS/Storage solutions for reliability and performance.
- Plan and configure networking hardware and VLAN segmentation.
- Understand domain name usage and SSL certificate requirements.
- Recognize the importance of a public IP or dynamic DNS service.
- Select appropriate power management solutions for your setup.

## Entry Checks

Before proceeding, ensure you have:

- Administrative access to your network and hardware.
- A planned budget for purchasing or upgrading hardware.
- Adequate physical space and power availability for your equipment.
- Basic understanding of virtualization and networking concepts.

---

## Lab 1: Workstation Requirements

### Description

A workstation acts as your primary interface for developing, configuring, and managing your homelab. This lab helps you review the minimum and recommended workstation hardware specifications.

### Workstation Hardware Requirements

| Resource | Minimum | Recommended |
|----------|---------|-------------|
| RAM      | 8 GB RAM | 16+ GB RAM |
| CPU      | Dual-core CPU | Quad-core or higher CPU |
| Storage   | 128 GB SSD | 256+ GB SSD/NVMe |

Operating System Support: Windows, macOS, Linux
Package managers such as Homebrew (macOS) and Chocolatey (Windows) simplify software installation.

### Validation

- [ ] I have identified a workstation that meets or exceeds the minimum hardware requirements.
- [ ] I understand the recommended specifications for better performance.
- [ ] My workstation's operating system supports the necessary software tools.

---

## Lab 2: Proxmox Nodes Specifications

### Description

Proxmox Nodes provide the compute power and virtualization capabilities to run multiple workloads. This lab reviews the hardware needed to build effective Proxmox Nodes.

### Proxmox Node Hardware Requirements

| Resource                      | Minimum             | Recommended         |
|-------------------------------|---------------------|---------------------|
| RAM                           | 8 GB RAM            | 32+ GB RAM          |
| CPU                           | Dual-core CPU       | Quad-core or higher CPU |
| Storage Type                  | Basic storage       | SSD/NVMe storage (prefer enterprise-grade) |
| Storage Size                  | 128 GB+ disk size   | 500 GB+ disk size   |
| Networking                   | 1 GbE NIC           | 10 GbE or multiple bonded NICs |
| Network Interface Cards (NICs)| 1 NIC               | Multiple NICs       |

**Optional Upgrades:**

- Increase NIC count for better network segmentation and redundancy.
- Add GPUs for hardware acceleration and GPU passthrough.

### Validation

- [ ] I have reviewed the minimum and recommended hardware for Proxmox Nodes.
- [ ] I have identified or planned for nodes that meet these specifications.
- [ ] I understand optional upgrades and their benefits.

---

## Lab 3: NAS/Storage Solutions

### Description

Reliable storage is essential for data protection, backups, and fast file access. This lab helps you evaluate NAS and Storage options suitable for your homelab.

### NAS/Storage Hardware Requirements

| Resource              | Minimum                  | Recommended                        |
|-----------------------|--------------------------|----------------------------------|
| Protocol Support      | NFS or SMB support       | NFS and iSCSI support            |
| Device                | Basic NFS-capable device | NAS with multiple drive bays     |
| Network Interface     | 1 GbE network interface  | 10 GbE networking                |
| RAID Support          | Optional                 | Required (RAID 1/5/6/10, etc.)  |
| NIC Count and Speed   | 1 x 1 GbE                | 2+ x 1/10 GbE                   |
| Expansion Options     | Not required             | Support for expansion units or JBOD |

### Validation

- [ ] I have reviewed the NAS/Storage protocols and device options.
- [ ] I have identified storage solutions that meet my data reliability and performance needs.
- [ ] I understand the importance of RAID and network interfaces for redundancy and throughput.

---

## Lab 4: Networking Hardware and VLANs

### Description

Networking hardware enables segmentation, security, and performance optimization. This lab covers the selection of switches, VLAN configuration, and network protocols.

### VLAN Example Table

| VLAN ID | Name         | Purpose                    | Minimum Devices          | Recommended Devices               |
|---------|--------------|----------------------------|--------------------------|---------------------------------|
| 10      | Management   | Network device management  | Optional                 | Separate VLAN for management      |
| 20      | Workstations | User devices               | Optional                 | Separate VLAN for workstations    |
| 30      | Servers      | Homelab servers            | Optional                 | Separate VLAN for servers         |
| 40      | IoT          | Internet of Things devices | Optional                 | Isolated VLAN for IoT             |

**Additional Notes:**

- Managed switches from UniFi, Cisco, or Netgear are recommended.
- Software options such as UniFi (default in this lab), pfSense, or OPNsense can handle routing and firewall duties.
- Use RJ45 with Cat6 or better for copper; SFP/SFP+ modules and fiber for higher speeds or longer distances.
- Port forwarding and firewall rules are essential for secure external access.
- Consider PoE (Power over Ethernet) capable switches if you plan to power APs or cameras.

### Validation

- [ ] I have reviewed VLAN segmentation best practices.
- [ ] I have identified networking hardware that supports my VLAN and performance requirements.
- [ ] I understand how to configure port forwarding and firewall rules.

---

## Lab 5: Domain Names and SSL Certificates

### Description

Domain names allow external and internal access to homelab services. This lab reviews public and private domain usage and SSL certificate considerations.

### Key Points

- Public domain names require valid SSL certificates (e.g., via Let's Encrypt or Cloudflare DNS-01).
- Private domains often use self-signed certificates or internal certificate authorities (CAs), requiring client configuration.
- Choose domain types based on access scope and security needs.
- SSL/TLS certificates should be automated where possible using ACME clients.

### Validation

- [ ] I understand the difference between public and private domain names.
- [ ] I have planned for SSL certificate acquisition or management.
- [ ] I know how to configure certificates for secure connections.

---

## Lab 6: Public IP and Dynamic DNS

### Description

Remote access to your homelab requires a static public IP or dynamic DNS service. This lab covers verifying your public IP and assessing internet speed.

### Verification Commands

```sh
curl -s ifconfig.me
curl -s https://ipinfo.io
```

### Speed Test Options

```sh
speedtest-cli
# or
curl -s https://raw.githubusercontent.com/sivel/speedtest-cli/master/speedtest.py | python -
```

### Additional Notes

- ISPs often provide asymmetric connections; upload speed is critical for hosting.
- Dynamic DNS services like DuckDNS, No-IP, or Cloudflare map changing IPs to fixed domain names.
- Consider IPv6 support for future-proofing and broader compatibility.
- For homelabs behind CGNAT, a VPN or tunneling service may be required for external access.

### Validation

- [ ] I have verified my public IP address or set up dynamic DNS.
- [ ] I have tested my internet upload and download speeds.
- [ ] I understand the impact of internet speed on hosting services.

---

## Lab 7: Power Management Solutions

### Description

Power management protects your homelab equipment and ensures uptime. This lab reviews power strip, surge protector, and UPS options.

### Power Management Options

- **Power Strip:** Multiple outlets, no surge or outage protection.
- **Surge Protector:** Protects against voltage spikes, no backup power.
- **Uninterruptible Power Supply (UPS):** Battery backup and surge protection.
- **Smart PDU:** Network-manageable power distribution with per-outlet control.

### UPS Sizing and Buying Guides

- [How to Size a UPS](https://www.apc.com/us/en/faqs/FA158499/)
- [Choosing the Right UPS](https://www.tripplite.com/ups-buying-guide)
- [UPS Buying Guide - Tom's Hardware](https://www.tomshardware.com/reviews/best-ups-uninterruptible-power-supply,6070.html)

### Validation

- [ ] I have selected appropriate power protection for my homelab.
- [ ] I understand the benefits of UPS units for uptime and data protection.
- [ ] I have budgeted for power management solutions.

---

## Exit Criteria

- [ ] I have identified or acquired a workstation that meets minimum requirements.
- [ ] I have selected or planned Proxmox Nodes with adequate compute, memory, storage, and networking.
- [ ] I have chosen NAS/Storage hardware appropriate for reliability, redundancy, and performance needs.
- [ ] I have planned networking hardware and VLAN segmentation.
- [ ] I understand domain name and SSL certificate requirements.
- [ ] I have verified public IP or dynamic DNS setup.
- [ ] I have selected power management solutions (UPS, surge, or smart PDU) for equipment protection.

---

Next → [Workstation Setup](02-Workstation-Setup.md)
