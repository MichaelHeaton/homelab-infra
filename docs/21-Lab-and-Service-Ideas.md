---
icon: material/lightbulb-on
---
# Lab & Service Ideas

Curated backlog for future labs and services. Prioritize as needed.

## Media and Home Services
- **Full automated Plex service (Usenet-only)**: Plex + Sonarr/Radarr/Lidarr + NZBGet/SABnzbd + Recyclarr. Exclude torrent clients to avoid ISP issues.
- **Image Management & Google Takeout Cleanup**: Immich or PhotoPrism, with EXIF normalization and deduplication pipeline.
- **DVD/Blu‑ray conversion for Plex**: MakeMKV + HandBrake + (optional) Tdarr for transcode automation.

## Gaming
- **Local Game Servers**: Minecraft, Valheim, Palworld, Factorio. Containerized with Portainer or Swarm stacks.

## AI and Tools
- **Private Local AI service**: Ollama + Open WebUI (text) and ComfyUI/InvokeAI (images). GPU optional.
- **Ticket system**: GLPI or Zammad for helpdesk plus inventory.
- **Local AI Doctor**: OpenHealthForAll – https://github.com/OpenHealthForAll/open-health

## Notes
- Prefer bind mounts on your `docker-lun` for persistence.
- Centralize secrets in Vault once deployed.
- Use Traefik labels for uniform ingress naming.
