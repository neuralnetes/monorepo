resource "google_dataflow_job" "dataflows" {
  for_each          = local.dataflows_map
  name              = each.value["name"]
  template_gcs_path = each.value["template_gcs_path"]
  temp_gcs_location = each.value["temp_gcs_location"]
  parameters        = each.value["parameters"]
  //  transform_name_mapping = each.value["transform_name_mapping"]
  on_delete             = each.value["on_delete"]
  max_workers           = each.value["max_workers"]
  service_account_email = each.value["service_account_email"]
  //  additional_experiments = each.value["additional_experiments"]
  machine_type     = each.value["machine_type"]
  labels           = each.value["labels"]
  ip_configuration = each.value["ip_configuration"]
  network          = each.value["network"]
  subnetwork       = each.value["subnetwork"]
  project          = each.value["project"]
  zone             = each.value["zone"]
  region           = each.value["region"]
}

locals {
  dataflows_map = {
    for dataflow in var.dataflows :
    dataflow["name"] => dataflow
  }
}