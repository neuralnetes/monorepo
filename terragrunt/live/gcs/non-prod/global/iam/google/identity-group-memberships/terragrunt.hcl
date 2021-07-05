terraform {
  source = "github.com/neuralnetes/monorepo.git//terraform/modules/google/identity-group-memberships?ref=main"
}

include {
  path = find_in_parent_folders()
}

dependency "service_accounts" {
  config_path = "${get_parent_terragrunt_dir()}/non-prod/global/iam/google/service-accounts"
}

dependency "identity_groups" {
  config_path = "${get_parent_terragrunt_dir()}/non-prod/global/iam/google/identity-groups"
}

dependency "terraform_project" {
  config_path = "${get_parent_terragrunt_dir()}/shared/global/shared/google/project"
}

generate "google_provider" {
  path      = "google_provider.tf"
  if_exists = "overwrite"
  contents  = <<-EOF
    provider "google" {
      billing_project = "${dependency.terraform_project.outputs.project_id}"
      user_project_override = true
      scopes = [
        "https://www.googleapis.com/auth/admin.directory.group",
        "https://www.googleapis.com/auth/admin.directory.user",
        "https://www.googleapis.com/auth/cloud-identity.groups",
        "https://www.googleapis.com/auth/cloud-platform",
        "https://www.googleapis.com/auth/userinfo.email"
      ]
    }
EOF
}

generate "google_beta_provider" {
  path      = "google_beta_provider.tf"
  if_exists = "overwrite"
  contents  = <<-EOF
    provider "google-beta" {
      billing_project = "${dependency.terraform_project.outputs.project_id}"
      user_project_override = true
      scopes = [
        "https://www.googleapis.com/auth/admin.directory.group",
        "https://www.googleapis.com/auth/admin.directory.user",
        "https://www.googleapis.com/auth/cloud-identity.groups",
        "https://www.googleapis.com/auth/cloud-platform",
        "https://www.googleapis.com/auth/userinfo.email"
      ]
    }
EOF
}

locals {
  gcp_workspace_domain_name = get_env("GCP_WORKSPACE_DOMAIN_NAME")
  kubeflow_admin_emails     = split(",", get_env("KUBEFLOW_ADMIN_EMAILS"))
  kubeflow_admin_service_account_ids_map = {
    for email in local.kubeflow_admin_emails :
    email => replace(
      split("@", email)[0],
      ".",
      "-"
    )
  }
  kubeflow_user_emails = split(",", get_env("KUBEFLOW_USER_EMAILS"))
  kubeflow_user_service_account_ids_map = {
    for email in local.kubeflow_user_emails :
    email => replace(
      split("@", email)[0],
      ".",
      "-"
    )
  }
}

inputs = {
  identity_group_memberships = flatten([
    [
      for email, service_account_id in local.kubeflow_admin_service_account_ids_map :
      {
        name          = "kubeflow-admin-${service_account_id}"
        group         = dependency.identity_groups.outputs.identity_groups_map["kubeflow-admin"].group_key[0].id
        roles_name    = "MEMBER"
        member_key_id = dependency.service_accounts.outputs.service_accounts_map[service_account_id].email
      }
    ],
    [
      for email, service_account_id in local.kubeflow_user_service_account_ids_map :
      {
        name          = "kubeflow-user-${service_account_id}"
        group         = dependency.identity_groups.outputs.identity_groups_map["kubeflow-user"].group_key[0].id
        roles_name    = "MEMBER"
        member_key_id = dependency.service_accounts.outputs.service_accounts_map[service_account_id].email
      }
    ]
  ])
}

skip = true