variable "mysqls" {
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