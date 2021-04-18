resource "grafana_data_source" "github_data_sources" {
  for_each = local.github_data_sources_map
  type     = "github"
  name     = each.value["name"]
  json_data {
    access_token         = each.value["json_data"]["access_token"]
    default_organization = each.value["json_data"]["default_organization"]
    default_repository   = each.value["json_data"]["default_repository"]
  }
}

locals {
  github_data_sources_map = {
    for data_source in var.github_data_sources :
    data_source["name"] => data_source
  }
}