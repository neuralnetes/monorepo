terraform {
  source = "github.com/neuralnetes/monorepo.git//terraform/modules/google/tags?ref=main"
}

include {
  path = find_in_parent_folders()
}

dependency "random_string" {
  config_path = "${get_parent_terragrunt_dir()}/non-prod/global/terraform/random/random-string"
}

dependency "auth" {
  config_path = "${get_parent_terragrunt_dir()}/non-prod/global/terraform/google/auth"
}

inputs = {
  random_string = dependency.random_string.outputs.result
  owner         = dependency.auth.outputs.email
}
