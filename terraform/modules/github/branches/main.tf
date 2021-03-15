data "github_branch" "branches" {
  for_each   = local.branches_map
  branch     = each.value["branch"]
  repository = each.value["repository"]
}

locals {
  branches_map = {
    for branch in var.branches :
    "${branch["repository"]}/${branch["branch"]}" => branch
  }
}
