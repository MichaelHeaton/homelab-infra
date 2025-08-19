# Vault deployment files

This folder holds the docker-compose file. It shares the same `.env.*` files so paths and IDs are defined once.

## Files
- `docker-compose.yaml`          CLI compose
- `.env.nas01`                  Env for Synology NAS01

## Usage

CLI:
```sh
cd docker/vault
docker compose --env-file .env.nas01 up -d
```
