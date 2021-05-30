resource "google_service_account_key" "service_account_keys" {
  for_each           = local.service_account_keys_map
  service_account_id = each.value["service_account_id"]
}

locals {
  service_account_keys_map = {
    for service_account_key in var.service_account_keys :
    split("@", service_account_key["service_account_id"])[0] => service_account_key
  }
}
