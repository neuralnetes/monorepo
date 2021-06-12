terraform {
  source = "github.com/neuralnetes/monorepo.git//terraform/modules/google/identity-group-memberships?ref=main"
}

include {
  path = find_in_parent_folders()
}

dependency "service_accounts" {
  config_path = "${get_parent_terragrunt_dir()}/non-prod/global/iam/google/service-accounts"
}

dependency "service_accounts" {
  config_path = "${get_parent_terragrunt_dir()}/non-prod/global/iam/google/service-accounts"
}

dependency "service_account_access_tokens" {
  config_path = "${get_parent_terragrunt_dir()}/non-prod/global/iam/google/service-account-access-tokens"
}

dependency "identity_groups" {
  config_path = "${get_parent_terragrunt_dir()}/non-prod/global/iam/google/identity-groups"
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
      access_token = "${dependency.service_account_access_tokens.outputs.service_account_access_tokens_map["terraform"].access_token}"
      user_project_override = true
      billing_project = "${dependency.terraform_project.outputs.project_id}"
    }
EOF
}

generate "google_beta_provider" {
  path      = "google_beta_provider.tf"
  if_exists = "overwrite_terragrunt"
  contents  = <<-EOF
    provider "google-beta" {
      access_token = "${dependency.service_account_access_tokens.outputs.service_account_access_tokens_map["terraform"].access_token}"
      user_project_override = true
      billing_project = "${dependency.terraform_project.outputs.project_id}"
    }
EOF
}

locals {
  gcp_workspace_domain_name = get_env("GCP_WORKSPACE_DOMAIN_NAME")
  kubeflow_admin_emails     = split(",", get_env("KUBEFLOW_ADMIN_EMAILS"))
  kubeflow_admins_map = {
    for email in local.kubeflow_admin_emails :
    email => {
      name = replace(
        replace(email, "@{local.gcp_workspace_domain_name}", ""),
        ".",
        "-"
      )
      email = email
    }
  }
  kubeflow_user_emails = split(",", get_env("KUBEFLOW_USER_EMAILS"))
  kubeflow_users_map = {
    for email in local.kubeflow_user_emails :
    email => {
      name = replace(
        replace(email, "@{local.gcp_workspace_domain_name}", ""),
        ".",
        "-"
      )
      email = email
    }
  }
}

inputs = {
  identity_group_memberships = flatten([
    [
      for email, kubeflow_user in local.kubeflow_users_map :
      {
        name          = "kubeflow-user-${kubeflow_user["name"]}"
        group         = dependency.identity_groups.outputs.identity_groups_map["kubeflow-user"].group_key[0].id
        roles_name    = "MEMBER"
        member_key_id = dependency.service_accounts.outputs.service_accounts_map[kubeflow_user["name"]].email
      }
    ],
    [
      for email, kubeflow_admin in local.kubeflow_admins_map :
      {
        name          = "kubeflow-admin-${kubeflow_admin["name"]}"
        group         = dependency.identity_groups.outputs.identity_groups_map["kubeflow-admin"].group_key[0].id
        roles_name    = "MEMBER"
        member_key_id = dependency.service_accounts.outputs.service_accounts_map[kubeflow_admin["name"]].email
      }
    ],
  ])
}
