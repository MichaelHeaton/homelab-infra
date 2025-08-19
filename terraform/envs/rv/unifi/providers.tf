# Default to local state so RV can work offline.
terraform {
  backend "local" {}
  # To switch later, replace with s3, http, or remote backend and push state.
}

# One provider per env controller
provider "unifi" {
  api_url  = var.controller_url
  username = var.controller_username
  password = var.controller_password
  # insecure = var.controller_insecure
}
