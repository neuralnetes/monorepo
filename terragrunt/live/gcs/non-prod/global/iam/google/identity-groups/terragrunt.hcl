terraform {
  source = "github.com/neuralnetes/monorepo.git//terraform/modules/google/identity-groups?ref=main"
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
  gcp_workspace_domain_name = get_env("GCP_WORKSPACE_DOMAIN_NAME")
  kubeflow_user_emails      = split(",", get_env("KUBEFLOW_USER_EMAILS"))
  kubeflow_admin_emails     = split(",", get_env("KUBEFLOW_ADMIN_EMAILS"))
}

inputs = {
  identity_groups = [
    {

    }
  ]
}
