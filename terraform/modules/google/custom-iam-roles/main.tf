module "custom_iam_roles" {
  for_each             = local.custom_iam_roles_map
  source               = "github.com/terraform-google-modules/terraform-google-iam.git//modules/custom_role_iam?ref=v7.2.0"
  target_level         = each.value["target_level"]
  target_id            = each.value["target_id"]
  role_id              = each.value["role_id"]
  title                = each.value["title"]
  description          = each.value["description"]
  base_roles           = each.value["base_roles"]
  permissions          = each.value["permissions"]
  excluded_permissions = each.value["excluded_permissions"]
  members              = each.value["members"]
}


locals {
  custom_iam_roles_map = {
    for custom_iam_role in var.custom_iam_roles :
    custom_iam_role["role_id"] => custom_iam_role
  }
}
