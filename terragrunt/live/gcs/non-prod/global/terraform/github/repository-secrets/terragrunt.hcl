terraform {
  source = "github.com/neuralnetes/monorepo.git//terraform/modules/github/repository-secrets?ref=main"
}

include {
  path = find_in_parent_folders()
}

dependency "repositories" {
  config_path = "${get_parent_terragrunt_dir()}/non-prod/global/terraform/github/repositories"
}

dependency "random_string" {
  config_path = "${get_parent_terragrunt_dir()}/non-prod/global/terraform/random/random-string"
}

inputs = {
  secrets = flatten([])
}