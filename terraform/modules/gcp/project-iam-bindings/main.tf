module "project-iam-bindings" {
  for_each = local.project_iam_bindings_map
  source   = "github.com/terraform-google-modules/terraform-google-iam.git//modules/projects_iam?ref=v6.4.0"
  bindings = each.value["bindings"]
  projects = each.value["projects"]
}

locals {
  project_iam_bindings_map = {
    for project_iam_binding in var.bindings :
    project_iam_binding["key"] => project_iam_binding
  }
}