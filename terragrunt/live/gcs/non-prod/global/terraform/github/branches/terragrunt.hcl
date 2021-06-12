terraform {
  source = "github.com/neuralnetes/monorepo.git//terraform/modules/github/branches?ref=main"
}

include {
  path = find_in_parent_folders()
}

dependency "repositories" {
  config_path = "${get_parent_terragrunt_dir()}/non-prod/global/terraform/github/repositories"
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
  branches = [
    for repo_key, repo in dependency.repositories.outputs.repositories_map :
    {
      repository = reverse(split("/", repo.full_name))[0]
      branch     = "main"
    }
  ]
}