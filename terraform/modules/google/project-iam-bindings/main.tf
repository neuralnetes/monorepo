module "project-iam-bindings" {
  for_each = local.project_iam_bindings_map
  source   = "github.com/terraform-google-modules/terraform-google-iam.git//modules/projects_iam?ref=v7.2.0"
  bindings = each.value["bindings"]
  projects = [each.value["project"]]
}

locals {
  project_iam_bindings_map = {
    for project_iam_binding in var.project_iam_bindings :
    project_iam_binding["name"] => project_iam_binding
  }
}