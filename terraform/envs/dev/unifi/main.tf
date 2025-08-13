module "site" {
  source = "../../../modules/unifi-site"
  site   = var.site

  # seed with nothing, add later per env
  networks = []
  wlans    = []
}
