terraform {
  source = "github.com/neuralnetes/monorepo.git//terraform/modules/github/repositories?ref=main"
}

include {
  path = find_in_parent_folders()
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

locals {
  github_repository = get_env("GITHUB_REPOSITORY")
}

inputs = {
  repositories = [
    {
      full_name = local.github_repository
    }
  ]
}