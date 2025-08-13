variable "controller_url"       { type = string }
variable "controller_username"  { type = string, sensitive = true }
variable "controller_password"  { type = string, sensitive = true }
# add env specific variables as needed, eg default VLAN ids, site name, etc.
