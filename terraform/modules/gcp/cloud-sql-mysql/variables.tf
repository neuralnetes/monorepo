variable "name" {
  type = string
}
variable "tier" {
  type = string
}
variable "region" {
  type = string
}
variable "ip_configuration_private_network" {
  type = string
}
variable "ip_configuration_ipv4_enabled" {
  type = bool
}
variable "database_version" {
  type = string
}
variable "ip_configuration_authorized_networks" {
  type = list(object({
    value = string
    name  = string
  }))
  default = []
}
variable "ip_configuration_require_ssl" {
  type    = bool
  default = true
}