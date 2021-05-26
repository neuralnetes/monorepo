data "google_service_account_access_token" "access_tokens" {
  for_each               = local.service_account_access_tokens_map
  target_service_account = each.value["target_service_account"]
  scopes                 = each.value["scopes"]
  lifetime               = each.value["lifetime"]
}

locals {
  service_account_access_tokens_map = {
    for service_account_access_token in var.service_account_access_tokens :
    split("@", service_account_access_token["target_service_account"])[0] => service_account_access_token
  }
}
