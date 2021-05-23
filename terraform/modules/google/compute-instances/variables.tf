variable "compute_instances" {
  type = list(object({
    name       = string
    project    = string
    location   = string
    network    = string
    subnetwork = string
  }))
}