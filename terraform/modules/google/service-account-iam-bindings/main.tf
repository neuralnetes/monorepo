module "service-account-iam-bindings" {
  for_each         = local.service_account_iam_bindings_map
  source           = "github.com/terraform-google-modules/terraform-google-iam.git//modules/service_accounts_iam?ref=v7.2.0"
  bindings         = each.value["bindings"]
  service_accounts = [each.value["service_account"]]
  project          = each.value["project"]
}

locals {
  service_account_iam_bindings_map = {
    for service_account_iam_binding in var.service_account_iam_bindings :
    service_account_iam_binding["name"] => service_account_iam_binding
  }
}