---
icon: material/lightbulb-on-outline
---
# Basic Hardware Requirements

## 💻 Workstation

A workstation is essential as the primary interface for development, configuration, and management of your homelab environment. It serves as the entry point for deploying and maintaining infrastructure components. On macOS, Homebrew is a popular package manager that simplifies installing software, while on Windows, Chocolatey serves a similar purpose for managing software installations and updates.

**Operating System Support: Windows, macOS, Linux**

| Resource                      | Minimum                          | Recommended                     | Author's Devices                   |
|-------------------------------|----------------------------------|---------------------------------|------------------------------------|
| RAM                           | 8 GB RAM                         | 16+ GB RAM                      | 16 GB RAM                          |
| CPU                           | Dual-core CPU                    | Quad-core or higher CPU         | Apple M1.                          |


## 🖥️ Proxmox Nodes

Compute capacity and virtualization capabilities are crucial for running multiple workloads efficiently within your homelab. Proxmox nodes provide the necessary resources to host virtual machines and containers, enabling flexible and scalable infrastructure. Official [Proxmox site](https://www.proxmox.com/) provides downloads, documentation, and support, and there are many online training resources for mastering Proxmox virtualization and clustering.

**CPU with virtualization support**

| Resource                      | Minimum                                   | Recommended                                   |
|-------------------------------|-------------------------------------------|-----------------------------------------------|
| RAM                           | 8 GB RAM                                  | 32+ GB RAM                                    |
| CPU                           | Dual-core CPU                             | Quad-core or higher CPU                       |
| Storage Type                  | Basic storage                             | SSD or NVMe storage                           |
| Storage Size                  | 128 GB+ disk size                         | 500 GB+ disk size                             |
| Network Interface Cards (NICs)| 1 NIC                                     | Multiple NICs                                 |

**Optional Upgrades:**

- Upgrade the number of NICs to improve network segmentation and redundancy.
- Add a GPU to a node to enable GPU passthrough for workloads that require hardware acceleration.

## 📦 NAS/Storage

Reliable storage is key for data reliability, backups, and fast access to files and media. NAS devices provide centralized storage solutions that support multiple protocols and ensure data availability and protection. NFS and iSCSI are preferred for homelab storage needs, but SMB can still be used for workstation file sharing. Storage can also be added directly to Proxmox nodes, which may improve performance but could impact redundancy and flexibility depending on your setup. Choosing the right protocols (NFS, iSCSI) depends on your use cases and client compatibility.

| Resource                      | Minimum                              | Recommended                                         | Author's Devices                  |
|-------------------------------|--------------------------------------|-----------------------------------------------------|-----------------------------------|
| Protocol Support              | NFS support                          | NFS and iSCSI support                               | NFS and iSCSI support             |
| Device                        | Basic NFS-capable device             | NAS with multiple drive bays                        | Synology DS1621+, UniFi UNAS      |
| Network Interface             | 1 GbE network interface              | 10 GbE networking                                   | 10 GbE SFP networking             |
| RAID Support                  | Optional                             | Required for redundancy (RAID 1/5/6/10, etc.)       | Supported on all                  |
| NIC Count and Speed           | 1 x 1 GbE                            | 2+ x 1/10 GbE for redundancy and throughput         | 2 x 1 GbE, 1 x 10 GbE             |

## 🌐 Networking

Networking hardware enables VLANs, segmentation, and performance optimization within your homelab. Proper network configuration ensures secure and efficient communication between devices and services. Hardware options include managed switches from vendors like UniFi, Cisco, or Netgear. Software options include pfSense or OpenWRT for routing and firewall capabilities. Basic network connections use RJ45 connectors with Cat5 or Cat6 cabling, while SFP modules and fiber connections can be used for higher speed or longer distance links. Port forwarding and firewall rules are essential for controlling external access to services securely.

**VLANs:**  
VLANs are considered best practice for network segmentation and security but are not strictly required. Implementing VLANs helps separate network traffic for management, workstations, servers, and IoT devices, improving performance and security.

**VLAN Example Table:**

| VLAN ID | Name         | Purpose                    | Minimum Devices          | Recommended Devices               | Author's Devices              |
|---------|--------------|----------------------------|--------------------------|-----------------------------------|-------------------------------|
| 10      | Management   | Network device management  | Optional                 | Separate VLAN for management      | VLAN 10                       |
| 20      | Workstations | User devices               | Optional                 | Separate VLAN for workstations    | VLAN 20                       |
| 30      | Servers      | Homelab servers            | Optional                 | Separate VLAN for servers         | VLAN 30                       |
| 40      | IoT          | Internet of Things devices | Optional                 | Isolated VLAN for IoT             | VLAN 40                       |

## 🌍 Domain Names

Domain names are vital for external accessibility and domain name resolution, allowing your homelab services to be reachable via human-friendly addresses. Public domain names are used for services accessible from the internet, enabling users to connect to your homelab remotely. Private domain names are typically used for internal network resolution only and are not accessible externally. Choosing between public and private domains depends on your intended access scope and security requirements.

**SSL Certificates:**  
- Public domain names require valid SSL certificates to secure connections. These can be obtained for free via services like Let's Encrypt or through other certificate authorities.  
- Private domains often use self-signed certificates or internal certificate authorities, which may require additional configuration on client devices to avoid trust warnings.

## 🌎 Public IP

A static public IP or dynamic DNS service is required to maintain consistent remote access to your homelab. This ensures that external clients can reliably connect to your infrastructure despite changing network conditions. Internet Service Providers (ISPs) often provide asymmetric internet connections, where download speeds are higher than upload speeds. Upload speed is particularly important for homelabs, as it affects how quickly data can be served to external clients.

To verify your public IP address, you can visit websites like [whatismyipaddress.com](https://whatismyipaddress.com/) or run command-line tools such as:
```sh
curl -s ifconfig.me
curl -s https://ipinfo.io
```

To check your internet speed, use:
```sh
speedtest-cli
# or
curl -s https://raw.githubusercontent.com/sivel/speedtest-cli/master/speedtest.py | python -
```

Running internet speed tests (e.g., via [speedtest.net](https://www.speedtest.net/)) helps assess your connection's upload and download speeds and can inform decisions about hosting services remotely. Dynamic DNS services like DuckDNS, No-IP, or Cloudflare can map changing IP addresses to fixed domain names, which is useful if you do not have a static IP.

## 🔋 Power Management

Proper power management is critical for protecting your homelab equipment and ensuring uptime. Selecting the appropriate power management solution depends on your setup, budget, and the criticality of uptime for your homelab.

- **Power Strip:** Provides multiple electrical outlets but offers no protection against power surges or outages. Useful for expanding outlet availability but does not safeguard equipment.  
- **Surge Protector:** Protects connected devices from voltage spikes and surges that can damage hardware. Does not provide backup power during outages.  
- **Uninterruptible Power Supply (UPS):** Provides battery backup power during outages, allowing safe shutdown of equipment and preventing data loss or hardware damage. UPS units also often include surge protection and power conditioning features.

**UPS Sizing and Buying Guides:**

- [How to Size a UPS](https://www.apc.com/us/en/faqs/FA158499/)  
- [Choosing the Right UPS](https://www.tripplite.com/ups-buying-guide)  
- [UPS Buying Guide - Tom's Hardware](https://www.tomshardware.com/reviews/best-ups-uninterruptible-power-supply,6070.html)
