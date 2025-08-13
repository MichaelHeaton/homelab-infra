# homelab-infra

Infrastructure as Code for UniFi based homelab.

## Layout
terraform/
modules/
unifi/{site,network,wlan,firewall,switch_port_profile}
envs/
core/   # shared infra and IoT friendly nets
dev/    # optional logical env
prod/   # optional logical env
rv/     # RV mini site, works offline with local state

## Usage
Export secrets, or create a local .auto.tfvars in the env folder, never commit secrets.

export TF_VAR_controller_url=“https://unifi-gw.local:8443”
export TF_VAR_controller_username=“admin”
export TF_VAR_controller_password=“REDACTED”
make init ENV=rv
make plan ENV=rv
