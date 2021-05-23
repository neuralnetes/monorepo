variable "compute_instances" {
  type = list(object({
    name                    = string
    machine_type            = string
    image_project           = string
    image_family            = string
    project                 = string
    zone                    = string
    network                 = string
    subnetwork              = string
    service_account_email   = string
    metadata_startup_script = string
    tags                    = list(string)
  }))
}