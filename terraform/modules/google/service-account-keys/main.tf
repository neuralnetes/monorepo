resource "google_service_account_key" "service_account_keys" {
  for_each = local.service_account_keys_map
  service_account_id = each.value["service_account_id"]
}

variable "service_account_keys" {
  type = list(object({
    service_account_id = string
  }))
}

locals {
  service_account_keys_map = {
    for service_account_key in var.service_account_keys:
    split("@", service_account_key["service_account_id"])[0]  => service_account_key
  }
}

output "service_account_keys_map" {
  value = google_service_account_key.service_account_keys
}