variable "cloud_nats" {
  type = list(object({
    name                               = string
    project_id                         = string
    router                             = string
    source_subnetwork_ip_ranges_to_nat = string
    subnetworks = list(object({
      name                     = string
      source_ip_ranges_to_nat  = list(string)
      secondary_ip_range_names = list(string)
    }))
    region = string
  }))
}
