variable "cloud_functions" {
  type = list(object({
    name                               = string
    description                        = string
    project_id                         = string
    region                             = string
    source_archive_bucket_name         = string
    source_archive_bucket_object_name  = string
    service_account_email              = string
    runtime                            = string
    entry_point                        = string
    environment_variables              = map(string)
    event_trigger                      = map(string)
    event_trigger_failure_policy_retry = bool
    labels                             = map(string)
    available_memory_mb                = number
    max_instances                      = number
    //    timeout_s                          = number
    //    ingress_settings                   = string
    //    vpc_connector_egress_settings      = string
    //    vpc_connector                      = string
  }))
}
