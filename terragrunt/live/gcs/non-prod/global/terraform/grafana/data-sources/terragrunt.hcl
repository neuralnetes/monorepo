terraform {
  source = "github.com/neuralnetes/monorepo.git//terraform/modules/grafana/data-sources?ref=main"
}

include {
  path = find_in_parent_folders()
}

dependency "random_string" {
  config_path = "${get_parent_terragrunt_dir()}/non-prod/global/terraform/random/random-string"
}

dependency "compute_project" {
  config_path = "${get_parent_terragrunt_dir()}/non-prod/global/compute/google/project"
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
    //    {
    //      name = "github-${dependency.random_string.outputs.result}"
    //      json_data = {
    //        owner      = get_env("GITHUB_OWNER")
    //        repository = reverse(split("/", get_env("GITHUB_REPOSITORY")))[0]
    //      }
    //      secure_json_data = {
    //        access_token = get_env("GITHUB_TOKEN")
    //      }
    //    }
  ]
  stackdriver_data_sources = [
    //    {
    //      name = "stackdriver-${dependency.compute_project.outputs.project_id}"
    //      json_data = {
    //        token_uri = "https://oauth2.googleapis.com/token"
    //        authentication_type = "jwt"
    //        default_project = "default-project"
    //        client_email = "client-email@default-project.iam.gserviceaccount.com"
    //      }
    //      secure_json_data = {
    //        private_key = "-----BEGIN PRIVATE KEY-----\nprivate-key\n-----END PRIVATE KEY-----\n"
    //      }
    //    }
  ]
}
