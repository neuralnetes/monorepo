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
  kubeflow_admin_emails     = split(",", get_env("KUBEFLOW_ADMIN_EMAILS"))
  kubeflow_admins_map = {
    for email in local.kubeflow_admin_emails :
    email => {
      name = replace(
        replace(email, "@${local.gcp_workspace_domain_name}", ""),
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
        replace(email, "@${local.gcp_workspace_domain_name}", ""),
        ".",
        "-"
      )
      email = email
    }
  }
  service_account_iam_bindings = values(
    merge(
      local.kubeflow_users_map,
      local.kubeflow_admins_map
    )
  )
}

inputs = {
  service_account_iam_bindings = flatten([
    [
      for service_account_iam_binding in local.service_account_iam_bindings :
      {
        name = service_account_iam_binding["name"]
        bindings = {
          for role in [
            "roles/iam.serviceAccountUser",
            "roles/iam.serviceAccountTokenCreator",
          ] :
          role => [
            "user:${service_account_iam_binding["email"]}"
          ]
        }
        service_account = dependency.service_accounts.outputs.service_accounts_map[service_account_iam_binding["name"]].email
        project         = dependency.iam_project.outputs.project_id
      }
    ]
  ])
}
