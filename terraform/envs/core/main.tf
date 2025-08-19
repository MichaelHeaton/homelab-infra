module "unifi" {
  source = "./unifi"

  # Environment label passed through to modules
  environment = var.environment
}
