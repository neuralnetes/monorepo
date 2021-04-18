resource "grafana_data_source" "github_data_sources" {
  for_each = local.github_data_sources_map
  type     = "github"
  name     = each.value["name"]
  json_data {
    owner      = each.value["json_data"]["owner"]
    repository = each.value["json_data"]["repository"]
  }

  secure_json_data {
    access_token = each.value["secure_json_data"]["access_token"]
  }
}

locals {
  github_data_sources_map = {
    for data_source in var.github_data_sources :
    data_source["name"] => data_source
  }
}