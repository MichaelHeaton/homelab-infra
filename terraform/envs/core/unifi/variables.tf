variable "controller_url"        { type = string }
variable "controller_username"   { type = string, sensitive = true }
variable "controller_password"   { type = string, sensitive = true }
variable "controller_insecure"   { type = bool,   default = false }
# optional default site for this env
variable "site"                  { type = string, default = "default" }
