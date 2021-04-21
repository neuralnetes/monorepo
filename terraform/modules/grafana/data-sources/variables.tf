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
  default = []
}

variable "stackdriver_data_sources" {
  type = list(object({
    name = string
    json_data = object({
      token_uri           = string
      authentication_type = string
      default_project     = string
      client_email        = string
    })
    secure_json_data = object({
      private_key = string
    })
  }))
  default = []
}