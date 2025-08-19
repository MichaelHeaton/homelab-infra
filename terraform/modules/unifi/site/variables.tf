variable "site" { type = string }
# Expand as you add, for now placeholders
variable "networks" { type = list(object({
  name = string
  vlan = number
})); default = [] }

variable "wlans" { type = list(object({
  name = string
  network = string
  passphrase = string
})); default = [] }
