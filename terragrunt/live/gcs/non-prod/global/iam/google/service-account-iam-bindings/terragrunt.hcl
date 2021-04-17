terraform {
  source = "github.com/neuralnetes/monorepo.git//terraform/modules/google/service-account-iam-bindings?ref=main"
}

include {
  path = find_in_parent_folders()
}

dependency "iam_project" {
  config_path = "${get_parent_terragrunt_dir()}/non-prod/global/iam/google/project"
}

dependency "compute_project" {
  config_path = "${get_parent_terragrunt_dir()}/non-prod/global/compute/google/project"
}

dependency "data_project" {
  config_path = "${get_parent_terragrunt_dir()}/non-prod/global/data/google/project"
}

dependency "network_project" {
  config_path = "${get_parent_terragrunt_dir()}/non-prod/global/network/google/project"
}

dependency "secret_project" {
  config_path = "${get_parent_terragrunt_dir()}/non-prod/global/secret/google/project"
}

dependency "service_accounts" {
  config_path = "${get_parent_terragrunt_dir()}/non-prod/global/iam/google/service-accounts"
}

dependency "service_account_datas" {
  config_path = "${get_parent_terragrunt_dir()}/non-prod/global/iam/google/service-account-datas"
}

dependency "random_string" {
  config_path = "${get_parent_terragrunt_dir()}/non-prod/global/terraform/random/random-string"
}

dependency "auth" {
  config_path = "${get_parent_terragrunt_dir()}/non-prod/global/terraform/google/auth"
}

locals {
  gcp_workspace_domain_name = get_env("GCP_WORKSPACE_DOMAIN_NAME")
}

inputs = {
  service_account_iam_bindings = [
    {
      bindings = {
        "roles/iam.serviceAccountUser" = [
          "serviceAccount:${dependency.service_accounts.outputs.service_accounts_map["cluster"].email}"
        ]
      }
      service_account = dependency.service_account_datas.outputs.service_account_datas_map["service-${dependency.compute_project.outputs.project_number}"].email
    }
  ]
}