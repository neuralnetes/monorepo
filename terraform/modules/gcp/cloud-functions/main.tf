module "cloud-functions" {
  for_each                           = local.cloud_functions_map
  source                             = "https://github.com/neuralnetes/monorepo.git//terraform/modules/gcp/cloud-function?ref=main"
  name                               = each.value["name"]
  region                             = each.value["region"]
  project_id                         = each.value["project_id"]
  source_archive_bucket_name         = each.value["source_archive_bucket_name"]
  source_archive_bucket_object_name  = each.value["source_archive_bucket_object_name"]
  description                        = each.value["description"]
  entry_point                        = each.value["entry_point"]
  event_trigger                      = each.value["event_trigger"]
  event_trigger_failure_policy_retry = each.value["event_trigger_failure_policy_retry"]
  runtime                            = each.value["runtime"]
  service_account_email              = each.value["service_account_email"]
  available_memory_mb                = each.value["available_memory_mb"]
  environment_variables              = each.value["environment_variables"]
  max_instances                      = each.value["max_instances"]
  labels                             = each.value["labels"]
}

locals {
  cloud_functions_map = {
    for cloud_function in var.cloud_functions :
    cloud_function["name"] => cloud_function
  }
}