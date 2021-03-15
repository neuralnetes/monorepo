module "service_accounts" {
  for_each      = local.service_accounts_map
  source        = "git::git@github.com:terraform-google-modules/terraform-google-service-accounts.git?ref=v3.0.1"
  project_id    = each.value["project_id"]
  prefix        = ""
  names         = [each.value["name"]]
  project_roles = each.value["project_roles"]
  //  grant_billing_role = each.value["grant_billing_role"]
  //  billing_account_id = each.value["billing_account_id"]
  //  grant_xpn_roles = each.value["grant_xpn_roles"]
  //  org_id = each.value["org_id"]
  //  generate_keys = each.value["generate_keys"]
  //  display_name = each.value["display_name"]
  //  description = each.value["description"]
}

locals {
  service_accounts_map = {
    for service_account in var.service_accounts :
    service_account["name"] => service_account
  }
}
