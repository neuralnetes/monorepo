variable "artifact_registries" {
  type = list(object({
    location      = string
    repository_id = string
    description   = string
    format        = string
    project       = string
  }))
}
