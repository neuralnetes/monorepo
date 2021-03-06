variable "cloud_dns" {
  type = list(object({
    project_id                         = string,
    type                               = string,
    name                               = string,
    domain                             = string
    private_visibility_config_networks = list(string)
    recordsets = list(object({
      name    = string
      type    = string
      ttl     = number
      records = list(string)
    }))
  }))
}