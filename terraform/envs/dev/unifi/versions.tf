terraform {
  required_version = ">= 1.7.5"
  required_providers {
    unifi = {
      source  = "ubiquiti-community/unifi"
      version = "~> 0.41"
    }
  }
}
