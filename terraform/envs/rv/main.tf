terraform {
  required_version = ">= 1.7.5"
  backend "local" {}
}

# provider "unifi" {
#   username = var.controller_username
#   password = var.controller_password
#   api_url  = var.controller_url
#   # Optional, eg insecure = false
# }

# Example module wiring, uncomment as you introduce resources
# module "site" {
#   source    = "../../modules/unifi/site"
#   # inputs...
# }
# module "network" { source = "../../modules/unifi/network" }
# module "wlan"    { source = "../../modules/unifi/wlan" }
# module "fw"      { source = "../../modules/unifi/firewall" }
# module "ports"   { source = "../../modules/unifi/switch_port_profile" }
