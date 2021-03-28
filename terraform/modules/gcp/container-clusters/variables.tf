variable "container_clusters" {
  type = list(object({
    ip_range_pods      = string
    ip_range_services  = string
    name               = string
    network            = string
    network_project_id = string
    node_pools = list(object({
      disk_size_gb = number
      disk_type    = string
      image_type   = string
      machine_type = string
      max_count    = number
      min_count    = number
      name         = string
      preemptible  = bool
    }))
    project_id      = string
    service_account = string
    subnetwork      = string
  }))
}
