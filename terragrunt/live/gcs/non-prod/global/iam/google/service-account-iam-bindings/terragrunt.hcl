terraform {
  source = "github.com/neuralnetes/monorepo.git//terraform/modules/google/service-account-iam-bindings?ref=main"
}

include {
  path = find_in_parent_folders()
}

dependency "compute_project" {
  config_path = "${get_parent_terragrunt_dir()}/non-prod/global/compute/google/project"
}

dependency "kubeflow_project" {
  config_path = "${get_parent_terragrunt_dir()}/non-prod/global/kubeflow/google/project"
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
  gcp_workspace_domain_name = get_env("GCP_WORKSPACE_DOMAIN_NAME")
}

inputs = {
  service_account_iam_bindings = [
    {
      name = "kubeflow-user-00"
      bindings = {
        for role in [
          "roles/iam.serviceAccountUser",
          "roles/iam.serviceAccountTokenCreator"
        ] :
        role => [
          for email in split(",", get_env("KUBEFLOW_USER_EMAILS")) :
          "user:${email}"
        ]
      }
      service_account = dependency.service_accounts.outputs.service_accounts_map["kubeflow-default-editor"].email
      project         = dependency.iam_project.outputs.project_id
    }
  ]
}
