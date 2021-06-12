terraform {
  source = "github.com/neuralnetes/monorepo.git//terraform/modules/google/custom-iam-roles?ref=main"
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

dependency "auth" {
  config_path = "${get_parent_terragrunt_dir()}/non-prod/global/terraform/google/auth"
}

locals {
  gcp_workspace_domain_name = get_env("GCP_WORKSPACE_DOMAIN_NAME")
  kubeflow_user_emails      = split(",", get_env("KUBEFLOW_USER_EMAILS"))
  kubeflow_users_map = {
    for kubeflow_user_email in local.kubeflow_user_emails :
    kubeflow_user_email => {
      user = kubeflow_user_email
      serviceAccount = replace(
        replace(kubeflow_user_email, "@{local.gcp_workspace_domain_name}", ""),
        ".",
        "-"
      )
    }
  }
  kubeflow_admin_emails = split(",", get_env("KUBEFLOW_ADMIN_EMAILS"))
  kubeflow_admins_map = {
    for kubeflow_user_email in local.kubeflow_user_emails :
    kubeflow_admin_email => {
      user = kubeflow_admin_email
      serviceAccount = replace(
        replace(kubeflow_admin_email, "@{local.gcp_workspace_domain_name}", ""),
        ".",
        "-"
      )
    }
  }
}

inputs = {
  custom_iam_roles = flatten([
    [
      for project in [
        dependency.artifact_project.outputs.project_id,
        dependency.compute_project.outputs.project_id,
        dependency.data_project.outputs.project_id,
        dependency.kubeflow_project.outputs.project_id,
        dependency.network_project.outputs.project_id,
        dependency.secret_project.outputs.project_id
      ] :
      {
        target_level = "project"
        target_id    = dependency.kubeflow_project.outputs.project_id
        role_id      = replace("kubeflow_users_${project}", "-", "_")
        title        = replace("kubeflow_users_${project}", "-", "_")
        description  = replace("kubeflow_users_${project}", "-", "_")
        base_roles = [
          "roles/artifactregistry.writer",
          "roles/container.clusterViewer",
          "roles/iap.httpsResourceAccessor"
        ]
        permissions = [
          "roles/artifactregistry.writer"
        ]
        excluded_permissions = []
        members = [
          for kubeflow_user_email, kubeflow_user in local.kubeflow_users_map :
          "serviceAccount:${dependency.service_accounts.outputs.service_accounts_map[kubeflow_user["serviceAccount"]]}"
        ]
      }
    ],
    [
      for project in [
        dependency.iam_project.outputs.project_id,
        dependency.compute_project.outputs.project_id,
        dependency.data_project.outputs.project_id,
        dependency.kubeflow_project.outputs.project_id,
        dependency.network_project.outputs.project_id,
        dependency.secret_project.outputs.project_id
      ] :
      {
        target_level = "project"
        target_id    = dependency.kubeflow_project.outputs.project_id
        role_id      = replace("kubeflow_admins_${project}", "-", "_")
        title        = replace("kubeflow_admins_${project}", "-", "_")
        description  = replace("kubeflow_admins_${project}", "-", "_")
        base_roles = [
          "roles/viewer",
        ]
        permissions = [
          "clientauthconfig.brands.create",
          "clientauthconfig.brands.get",
          "clientauthconfig.brands.update",
          "clientauthconfig.clients.create",
          "clientauthconfig.clients.get",
          "clientauthconfig.clients.list",
          "clientauthconfig.clients.update",
          "iam.serviceAccounts.list",
          "oauthconfig.testusers.get",
          "oauthconfig.testusers.update",
          "oauthconfig.verification.get",
          "oauthconfig.verification.update",
          "resourcemanager.projects.get",
          "serviceusage.services.list"
        ]
        excluded_permissions = []
        members = [
          for kubeflow_admin_email, kubeflow_admin in local.kubeflow_admins_map :
          "serviceAccount:${dependency.service_accounts.outputs.service_accounts_map[kubeflow_user["serviceAccount"]]}"
        ]
      }
    ]
  ])
}
