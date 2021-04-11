variable "container_cluster_auths" {
  type = list(object({
    project_id   = string
    cluster_name = string
    location     = string
  }))
}