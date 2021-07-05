variable "service_project_subnetworks" {
  type = list(object({
    host_project_id      = string
    service_project_id   = string
    subnetwork_self_link = string
    region               = string
  }))
}