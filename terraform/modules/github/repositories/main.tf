data "github_repository" "repositories" {
  for_each  = local.repositories_map
  full_name = each.value["full_name"]
}

locals {
  repositories_map = {
    for repository in var.repositories :
    repository["full_name"] => repository
  }
}
