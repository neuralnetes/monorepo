variable "artifact_registry_repositories" {
  type = list(object({
    location      = string
    repository_id = string
    description   = string
    format        = string
    project       = string
  }))
}
