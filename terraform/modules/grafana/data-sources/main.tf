resource "grafana_data_source" "stackdriver_data_sources" {
  for_each = local.stackdriver_data_sources_map
  type     = "stackdriver"
  name     = each.value["name"]
  json_data {
    token_uri           = each.value["json_data"]["token_uri"]
    authentication_type = each.value["json_data"]["authentication_type"]
    default_project     = each.value["json_data"]["default_project"]
    client_email        = each.value["json_data"]["client_email"]
  }

  secure_json_data {
    private_key = each.value["secure_json_data"]["private_key"]
  }
}

locals {
  stackdriver_data_sources_map = {
    for data_source in var.stackdriver_data_sources :
    data_source["name"] => data_source
  }
}