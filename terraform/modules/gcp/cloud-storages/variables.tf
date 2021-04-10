variable "cloud_storages" {
  type = list(object({
    location   = string
    name       = string
    project_id = string
    versioning = bool
  }))
}