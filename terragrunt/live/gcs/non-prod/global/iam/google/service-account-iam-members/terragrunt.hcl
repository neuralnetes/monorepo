terraform {
  source = "github.com/neuralnetes/monorepo.git//terraform/modules/google/service-account-iam-members?ref=main"
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

dependency "service_accounts" {
  config_path = "${get_parent_terragrunt_dir()}/non-prod/global/iam/google/service-accounts"
}

dependency "project_iam_bindings" {
  config_path = "${get_parent_terragrunt_dir()}/non-prod/global/iam/google/project-iam-bindings"
}

dependency "random_string" {
  config_path = "${get_parent_terragrunt_dir()}/non-prod/global/terraform/random/random-string"
}

locals {
  gcp_workspace_domain_name = get_env("GCP_WORKSPACE_DOMAIN_NAME")
}

inputs = {
  service_account_iam_members = [
    {
      service_account_id = dependency.service_accounts.outputs.service_accounts_map["cluster-${dependency.random_string.outputs.result}"].service_account.name
      role               = "roles/iam.serviceAccountUser"
      member             = "group:terraform@${local.gcp_workspace_domain_name}"
    },
    {
      service_account_id = dependency.service_accounts.outputs.service_accounts_map["cluster-${dependency.random_string.outputs.result}"].service_account.name
      role               = "roles/iam.serviceAccountUser"
      member             = "serviceAccount:${dependency.compute_project.outputs.service_account_email}"
    },
  ]
}
