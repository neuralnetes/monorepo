terraform {
  source = "github.com/neuralnetes/monorepo.git//terraform/modules/grafana/data-sources?ref=main"
}

include {
  path = find_in_parent_folders()
}

dependency "random_string" {
  config_path = "${get_parent_terragrunt_dir()}/non-prod/global/terraform/random/random-string"
}

generate "grafana_provider" {
  path      = "grafana_provider.tf"
  if_exists = "overwrite_terragrunt"
  contents  = <<-EOF
    terraform {
      required_providers {
        grafana = {
          source = "grafana/grafana"
          version = "1.9.0"
        }
      }
    }
    provider "grafana" {}
EOF
}

inputs = {
  github_data_sources = [
    {
      name = "github-${dependency.random_string.outputs.result}"
      json_data = {
        access_token         = get_env("GITHUB_TOKEN")
        default_organization = get_env("GITHUB_OWNER")
        default_repository   = reverse(split("/", get_env("GITHUB_REPOSITORY")))[0]
      }
    }
  ]
}
