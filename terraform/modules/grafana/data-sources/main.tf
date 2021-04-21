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

resource "grafana_data_source" "stackdriver_data_sources" {
  for_each = local.github_data_sources_map
  type     = "stackdriver"
  name     = each.value["name"]
  json_data {
    token_uri           = each.value["token_uri"]
    authentication_type = each.value["authentication_type"]
    default_project     = each.value["default_project"]
    client_email        = each.value["client_email"]
  }

  secure_json_data {
    private_key = each.value["private_key"]
  }
}

locals {
  github_data_sources_map = {
    for data_source in var.github_data_sources :
    data_source["name"] => data_source
  }
  stackdriver_data_sources_map = {
    for data_source in var.stackdriver_data_sources :
    data_source["name"] => data_source
  }
}