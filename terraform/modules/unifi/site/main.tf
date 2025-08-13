terraform {
  required_version = ">= 1.7.5"
  required_providers {
    # TODO choose provider, eg:
    # unifi = { source = "paultyng/unifi", version = "~> 0.45" }
  }
}
# TODO module inputs to manage UniFi Site, eg site_name
# resource "unifi_site" "this" { /* ... */ }
