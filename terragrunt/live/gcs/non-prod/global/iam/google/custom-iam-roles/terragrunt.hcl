terraform {
  source = "github.com/neuralnetes/monorepo.git//terraform/modules/google/custom-iam-roles?ref=main"
}

include {
  path = find_in_parent_folders()
}

dependency "kubeflow_project" {
  config_path = "${get_parent_terragrunt_dir()}/non-prod/global/kubeflow/google/project"
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
        dependency.kubeflow_project.outputs.project_id,
      ] :
      {
        target_level         = "project"
        target_id            = project
        role_id              = replace("kubeflow_user_${project}", "-", "_")
        title                = replace("kubeflow_user_${project}", "-", "_")
        description          = replace("kubeflow_user_${project}", "-", "_")
        base_roles           = []
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
        dependency.kubeflow_project.outputs.project_id,
      ] :
      {
        target_level         = "project"
        target_id            = project
        role_id              = replace("kubeflow_admin_${project}", "-", "_")
        title                = replace("kubeflow_admin_${project}", "-", "_")
        description          = replace("kubeflow_admin_${project}", "-", "_")
        base_roles           = []
        permissions          = []
        excluded_permissions = []
        members = [
          "group:${dependency.identity_groups.outputs.identity_groups_map["kubeflow-admin"].group_key[0].id}"
        ]
      }
    ]
  ])
}

skip = true
