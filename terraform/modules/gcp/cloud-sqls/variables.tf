variable "mysqls" {
  type = list(object({
    name                             = string
    tier                             = string
    region                           = string
    database_version                 = string
    project                          = string
    ip_configuration_private_network = string
    ip_configuration_ipv4_enabled    = string
    ip_configuration_authorized_networks = list(object({
      value = string
      name  = string
    }))
    ip_configuration_require_ssl = string
  }))
}
variable "postgresqls" {
  type = list(object({
    database_version = string
    name             = string
    project_id       = string
    region           = string
    zone             = string
    ip_configuration = object({
      authorized_networks = list(map(string))
      ipv4_enabled        = bool
      private_network     = string
      require_ssl         = bool
    })
  }))
  default = []
}