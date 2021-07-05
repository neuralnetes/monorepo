terraform {
  source = "github.com/neuralnetes/monorepo.git//terraform/modules/github/repository-secrets?ref=main"
}

include {
  path = find_in_parent_folders()
}

dependency "repositories" {
  config_path = "${get_parent_terragrunt_dir()}/shared/global/shared/github/repositories"
}

dependency "random_string" {
  config_path = "${get_parent_terragrunt_dir()}/shared/global/shared/random/random-string"
}

generate "github_provider" {
  path      = "github_provider.tf"
  if_exists = "overwrite_terragrunt"
  contents  = <<-EOF
    terraform {
      required_providers {
        github = {
          source  = "integrations/github"
          version = "4.11.0"
        }
      }
    }
    provider "github" {}
EOF
}

inputs = {
  secrets = flatten([])
}