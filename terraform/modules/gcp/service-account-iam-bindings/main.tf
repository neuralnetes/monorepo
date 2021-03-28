module "service-account-iam-bindings" {
  for_each         = local.service_account_iam_bindings_map
  source           = "https://github.com/terraform-google-modules/terraform-google-iam.git//modules/service_accounts_iam?ref=v6.4.0"
  project          = each.value["project"]
  bindings         = each.value["bindings"]
  service_accounts = [each.value["service_account"]]
}

locals {
  service_account_iam_bindings_map = {
    for service_account_iam_binding in var.bindings :
    service_account_iam_binding["service_account"] => service_account_iam_binding
  }
}