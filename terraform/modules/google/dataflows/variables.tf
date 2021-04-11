variable "dataflows" {
  type = list(object({
    name              = string
    template_gcs_path = string
    temp_gcs_location = string
    parameters        = map(string)
    labels            = map(string)
    //    transform_name_mapping = map(string)
    max_workers      = number
    on_delete        = string
    ip_configuration = string
    //    additional_experiments = list(string)
    project               = string
    zone                  = string
    region                = string
    network               = string
    subnetwork            = string
    machine_type          = string
    service_account_email = string
    machine_type          = string
    labels                = map(string)
  }))
}
