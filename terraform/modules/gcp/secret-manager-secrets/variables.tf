variable "secret_manager_secrets" {
  type = list(object({
    project_id  = string
    secret_id   = string
    secret_data = string
    replication = object({
      automatic = bool
    })
  }))
}