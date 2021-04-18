variable "github_data_sources" {
  type = list(object({
    name = string
    json_data = object({
      access_token         = string
      default_organization = string
      default_repository   = string
    })
  }))
}