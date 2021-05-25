terraform {
  source = "github.com/neuralnetes/monorepo.git//terraform/modules/google/service-account-iam-bindings?ref=main"
}

include {
  path = find_in_parent_folders()
}

dependency "iam_project" {
  config_path = "${get_parent_terragrunt_dir()}/non-prod/global/iam/google/project"
}

dependency "service_accounts" {
  config_path = "${get_parent_terragrunt_dir()}/non-prod/global/iam/google/service-accounts"
}

dependency "project_iam_bindings" {
  config_path = "${get_parent_terragrunt_dir()}/non-prod/global/iam/google/project-iam-bindings"
}

dependency "auth" {
  config_path = "${get_parent_terragrunt_dir()}/non-prod/global/terraform/google/auth"
}

locals {
  gsuite_domain_name = get_env("GCP_WORKSPACE_DOMAIN_NAME")
}

inputs = {
  service_account_iam_bindings = [
    for service_account_name, service_account in dependency.service_accounts.outputs.service_accounts_map :
    {
      bindings = {
        for role in [
          "roles/iam.serviceAccountUser",
          "roles/iam.serviceAccountTokenCreator"
        ] :
        role => [
          "serviceAccount:${dependency.auth.outputs.email}"
        ]
      }
      service_account = service_account.email
      project         = dependency.iam_project.outputs.project_id
    }
  ]
}
