variable "github_data_sources" {
  type = list(object({
    name = string
    json_data = object({
      owner      = string
      repository = string
    })
    secure_json_data = object({
      access_token = string
    })
  }))
}