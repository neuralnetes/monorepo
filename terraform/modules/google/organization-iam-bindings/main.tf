module "organization-iam-bindings" {
  for_each      = local.organization_iam_bindings_map
  source        = "github.com/terraform-google-modules/terraform-google-iam.git//modules/organizations_iam?ref=v7.2.0"
  bindings      = each.value["bindings"]
  organizations = [each.value["organization"]]
}

locals {
  organization_iam_bindings_map = {
    for organization_iam_binding in var.bindings :
    organization_iam_binding["organization"] => organization_iam_binding
  }
}