resource "google_service_account" "service-accounts" {
  for_each   = local.service_accounts_map
  project    = each.value["project"]
  account_id = each.value["account_id"]
}

data "google_service_account" "service-account-datas" {
  for_each   = local.service_account_datas_map
  project    = each.value["project"]
  account_id = each.value["account_id"]
}

locals {
  service_accounts_map = {
    for service_account in var.service_accounts :
    split("@", service_account["account_id"])[0] => service_account
  }
  service_account_datas_map = {
    for service_account in var.service_account_datas :
    split("@", service_account["account_id"])[0] => service_account
  }
}
