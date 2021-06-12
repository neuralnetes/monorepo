terraform {
  source = "github.com/neuralnetes/monorepo.git//terraform/modules/google/identity-groups?ref=main"
}

include {
  path = find_in_parent_folders()
}

dependency "terraform_project" {
  config_path = "${get_parent_terragrunt_dir()}/non-prod/global/terraform/google/project"
}

dependency "service_account_access_tokens" {
  config_path = "${get_parent_terragrunt_dir()}/non-prod/global/iam/google/service-account-access-tokens"
}

generate "google_provider" {
  path      = "google_provider.tf"
  if_exists = "overwrite_terragrunt"
  contents  = <<-EOF
    provider "google" {
      scopes = "${local.scopes}"
    }
EOF
}

generate "google_beta_provider" {
  path      = "google_beta_provider.tf"
  if_exists = "overwrite_terragrunt"
  contents  = <<-EOF
    provider "google-beta" {
      scopes = "${local.scopes}"
    }
EOF
}

locals {
  gcp_workspace_customer_id = get_env("GCP_WORKSPACE_CUSTOMER_ID")
  gcp_workspace_domain_name = get_env("GCP_WORKSPACE_DOMAIN_NAME")
  scopes = [
    "https://www.googleapis.com/auth/cloud-platform",
    "https://www.googleapis.com/auth/userinfo.email",
    "https://www.googleapis.com/auth/cloud-identity.groups",
    "https://www.googleapis.com/auth/admin.directory.user",
    "https://www.googleapis.com/auth/admin.directory.group"
  ]
}

inputs = {
  identity_groups = [
    for display_name in ["kubeflow-user", "kubeflow-admin"] :
    {
      display_name = display_name
      parent       = "customers/${local.gcp_workspace_customer_id}"
      group_key_id = "${display_name}@${local.gcp_workspace_domain_name}"
    }
  ]
}
