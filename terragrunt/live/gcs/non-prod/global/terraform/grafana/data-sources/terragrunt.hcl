terraform {
  source = "github.com/neuralnetes/monorepo.git//terraform/modules/grafana/data-sources?ref=main"
}

include {
  path = find_in_parent_folders()
}

dependency "random_string" {
  config_path = "${get_parent_terragrunt_dir()}/non-prod/global/terraform/random/random-string"
}

dependency "iam_project" {
  config_path = "${get_parent_terragrunt_dir()}/non-prod/global/iam/google/project"
}

dependency "kubeflow_project" {
  config_path = "${get_parent_terragrunt_dir()}/non-prod/global/kubeflow/google/project"
}

dependency "management_project" {
  config_path = "${get_parent_terragrunt_dir()}/non-prod/global/management/google/project"
}

dependency "service_accounts" {
  config_path = "${get_parent_terragrunt_dir()}/non-prod/global/iam/google/service-accounts"
}

dependency "service_account_keys" {
  config_path = "${get_parent_terragrunt_dir()}/non-prod/global/iam/google/service-account-keys"
}

dependency "project_iam_bindings" {
  config_path = "${get_parent_terragrunt_dir()}/non-prod/global/iam/google/project-iam-bindings"
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
  stackdriver_data_sources = [
    {
      name = "stackdriver-${dependency.kubeflow_project.outputs.project_id}"
      json_data = {
        token_uri           = "https://oauth2.googleapis.com/token"
        authentication_type = "jwt"
        default_project     = dependency.kubeflow_project.outputs.project_id
        client_email        = dependency.service_accounts.outputs.service_accounts_map["grafana-cloud"].email
      }
      secure_json_data = {
        private_key = jsonencode(jsondecode(base64decode(
          dependency.service_account_keys.outputs.service_account_keys_map["grafana-cloud"].private_key
        )))
      }
    },
    {
      name = "stackdriver-${dependency.management_project.outputs.project_id}"
      json_data = {
        token_uri           = "https://oauth2.googleapis.com/token"
        authentication_type = "jwt"
        default_project     = dependency.management_project.outputs.project_id
        client_email        = dependency.service_accounts.outputs.service_accounts_map["grafana-cloud"].email
      }
      secure_json_data = {
        private_key = jsonencode(jsondecode(base64decode(
          dependency.service_account_keys.outputs.service_account_keys_map["grafana-cloud"].private_key
        )))
      }
    }
  ]
}

skip = true