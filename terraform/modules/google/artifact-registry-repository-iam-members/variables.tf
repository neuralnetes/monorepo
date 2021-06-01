variable "artifact_registry_repository_iam_members" {
  type = list(object({
    name       = string
    location   = string
    repository = string
    role       = string
    member     = string
    project    = string
  }))
}
