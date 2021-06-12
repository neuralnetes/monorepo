terraform {
  source = "github.com/neuralnetes/monorepo.git//terraform/modules/google/custom-iam-roles?ref=main"
}

include {
  path = find_in_parent_folders()
}

dependency "artifact_project" {
  config_path = "${get_parent_terragrunt_dir()}/non-prod/global/artifact/google/project"
}

dependency "iam_project" {
  config_path = "${get_parent_terragrunt_dir()}/non-prod/global/iam/google/project"
}

dependency "terraform_project" {
  config_path = "${get_parent_terragrunt_dir()}/non-prod/global/terraform/google/project"
}

dependency "kubeflow_project" {
  config_path = "${get_parent_terragrunt_dir()}/non-prod/global/kubeflow/google/project"
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

dependency "identity_groups" {
  config_path = "${get_parent_terragrunt_dir()}/non-prod/global/iam/google/identity-groups"
}

locals {
  gcp_workspace_domain_name = get_env("GCP_WORKSPACE_DOMAIN_NAME")
}

inputs = {
  custom_iam_roles = flatten([
    # kubeflow-user
    [
      for project in [
        dependency.artifact_project.outputs.project_id,
      ] :
      {
        target_level = "project"
        target_id    = project
        role_id      = replace("kubeflow_user_${project}", "-", "_")
        title        = replace("kubeflow_user_${project}", "-", "_")
        description  = replace("kubeflow_user_${project}", "-", "_")
        base_roles = [
          "roles/artifactregistry.reader"
        ]
        permissions          = []
        excluded_permissions = []
        members = [
          "group:${dependency.identity_groups.outputs.identity_groups_map["kubeflow-user"].group_key[0].id}"
        ]
      }
    ],
    [
      for project in [
        dependency.kubeflow_project.outputs.project_id,
      ] :
      {
        target_level = "project"
        target_id    = project
        role_id      = replace("kubeflow_user_${project}", "-", "_")
        title        = replace("kubeflow_user_${project}", "-", "_")
        description  = replace("kubeflow_user_${project}", "-", "_")
        base_roles = [
          "roles/container.clusterViewer"
        ]
        permissions          = []
        excluded_permissions = []
        members = [
          "group:${dependency.identity_groups.outputs.identity_groups_map["kubeflow-user"].group_key[0].id}"
        ]
      }
    ],
    [
      for project in [
        dependency.data_project.outputs.project_id,
      ] :
      {
        target_level = "project"
        target_id    = project
        role_id      = replace("kubeflow_user_${project}", "-", "_")
        title        = replace("kubeflow_user_${project}", "-", "_")
        description  = replace("kubeflow_user_${project}", "-", "_")
        base_roles = [
          "roles/storage.admin"
        ]
        permissions          = []
        excluded_permissions = []
        members = [
          "group:${dependency.identity_groups.outputs.identity_groups_map["kubeflow-user"].group_key[0].id}"
        ]
      }
    ],
    # kubeflow-admin
    [
      for project in [
        dependency.artifact_project.outputs.project_id,
      ] :
      {
        target_level = "project"
        target_id    = project
        role_id      = replace("kubeflow_admin_${project}", "-", "_")
        title        = replace("kubeflow_admin_${project}", "-", "_")
        description  = replace("kubeflow_admin_${project}", "-", "_")
        base_roles = [
          "roles/viewer",
          "roles/artifactregistry.writer"
        ]
        permissions          = []
        excluded_permissions = []
        members = [
          "group:${dependency.identity_groups.outputs.identity_groups_map["kubeflow-admin"].group_key[0].id}"
        ]
      }
    ],
    [
      for project in [
        dependency.iam_project.outputs.project_id,
      ] :
      {
        target_level = "project"
        target_id    = project
        role_id      = replace("kubeflow_admin_${project}", "-", "_")
        title        = replace("kubeflow_admin_${project}", "-", "_")
        description  = replace("kubeflow_admin_${project}", "-", "_")
        base_roles = [
          "roles/viewer"
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
          "group:${dependency.identity_groups.outputs.identity_groups_map["kubeflow-admin"].group_key[0].id}"
        ]
      }
    ],
    [
      for project in [
        dependency.kubeflow_project.outputs.project_id,
        dependency.compute_project.outputs.project_id,
      ] :
      {
        target_level = "project"
        target_id    = project
        role_id      = replace("kubeflow_admin_${project}", "-", "_")
        title        = replace("kubeflow_admin_${project}", "-", "_")
        description  = replace("kubeflow_admin_${project}", "-", "_")
        base_roles = [
          "roles/viewer",
          "roles/compute.admin",
          "roles/container.admin"
        ]
        permissions          = []
        excluded_permissions = []
        members = [
          "group:${dependency.identity_groups.outputs.identity_groups_map["kubeflow-admin"].group_key[0].id}"
        ]
      }
    ],
    [
      for project in [
        dependency.data_project.outputs.project_id,
      ] :
      {
        target_level = "project"
        target_id    = project
        role_id      = replace("kubeflow_admin_${project}", "-", "_")
        title        = replace("kubeflow_admin_${project}", "-", "_")
        description  = replace("kubeflow_admin_${project}", "-", "_")
        base_roles = [
          "roles/viewer"
        ]
        permissions          = []
        excluded_permissions = []
        members = [
          "group:${dependency.identity_groups.outputs.identity_groups_map["kubeflow-admin"].group_key[0].id}"
        ]
      }
    ],
    [
      for project in [
        dependency.secret_project.outputs.project_id,
      ] :
      {
        target_level = "project"
        target_id    = project
        role_id      = replace("kubeflow_admin_${project}", "-", "_")
        title        = replace("kubeflow_admin_${project}", "-", "_")
        description  = replace("kubeflow_admin_${project}", "-", "_")
        base_roles = [
          "roles/viewer"
        ]
        permissions          = []
        excluded_permissions = []
        members = [
          "group:${dependency.identity_groups.outputs.identity_groups_map["kubeflow-admin"].group_key[0].id}"
        ]
      }
    ],
  ])
}
