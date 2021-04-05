terraform {
  source = "github.com/neuralnetes/monorepo.git//terraform/modules/gcp/project-iam-bindings?ref=main"
}

include {
  path = find_in_parent_folders()
}

dependency "iam_project" {
  config_path = "${get_parent_terragrunt_dir()}/non-prod/global/iam/gcp/project"
}

dependency "service_accounts" {
  config_path = "${get_parent_terragrunt_dir()}/non-prod/global/iam/gcp/service-accounts"
}

dependency "compute_project" {
  config_path = "${get_parent_terragrunt_dir()}/non-prod/global/compute/gcp/project"
}

dependency "data_project" {
  config_path = "${get_parent_terragrunt_dir()}/non-prod/global/data/gcp/project"
}

dependency "network_project" {
  config_path = "${get_parent_terragrunt_dir()}/non-prod/global/network/gcp/project"
}

dependency "secret_project" {
  config_path = "${get_parent_terragrunt_dir()}/non-prod/global/secret/gcp/project"
}

dependency "random_string" {
  config_path = "${get_parent_terragrunt_dir()}/non-prod/global/terraform/random/random-string"
}

dependency "auth" {
  config_path = "${get_parent_terragrunt_dir()}/non-prod/global/terraform/gcp/auth"
}

locals {
  gcp_workspace_domain_name = get_env("GCP_WORKSPACE_DOMAIN_NAME")
}

inputs = {
  bindings = flatten([
    # compute
    [
      {
        key = "${dependency.compute_project.outputs.project_id}-01"
        bindings = {
          for project_role in [
            "roles/compute.admin",
            "roles/iam.serviceAccountAdmin"
          ] :
          project_role => [
            "group:terraform@${local.gcp_workspace_domain_name}"
          ]
        }
        projects = [dependency.compute_project.outputs.project_id]
      },
      {
        key = "${dependency.compute_project.outputs.project_id}-02"
        bindings = {
          for project_role in [
            "roles/viewer",
          ] :
          project_role => [
            "group:engineering@${local.gcp_workspace_domain_name}"
          ]
        }
        projects = [dependency.compute_project.outputs.project_id]
      }
    ],
    # data
    [
      {
        key = "${dependency.data_project.outputs.project_id}-01"
        bindings = {
          for project_role in [
            "roles/storage.admin",
            "roles/bigquery.admin",
            "roles/pubsub.admin",
          ] :
          project_role => [
            "group:terraform@${local.gcp_workspace_domain_name}"
          ]
        }
        projects = [dependency.data_project.outputs.project_id]
      },
      {
        key = "${dependency.data_project.outputs.project_id}-02"
        bindings = {
          for project_role in [
            "roles/viewer",
          ] :
          project_role => [
            "group:engineering@${local.gcp_workspace_domain_name}"
          ]
        }
        projects = [dependency.data_project.outputs.project_id]
      }
    ],
    # iam
    [
      {
        key = "${dependency.iam_project.outputs.project_id}-01"
        bindings = {
          for project_role in [
            "roles/iam.serviceAccountAdmin",
            "roles/iam.serviceAccountKeyAdmin",
          ] :
          project_role => [
            "group:terraform@${local.gcp_workspace_domain_name}"
          ]
        }
        projects = [dependency.iam_project.outputs.project_id]
      },
      {
        key = "${dependency.iam_project.outputs.project_id}-02"
        bindings = {
          for project_role in [
            "roles/viewer",
          ] :
          project_role => [
            "group:engineering@${local.gcp_workspace_domain_name}"
          ]
        }
        projects = [dependency.iam_project.outputs.project_id]
      }
    ],
    # network
    [
      {
        key = "${dependency.network_project.outputs.project_id}-01"
        bindings = {
          for project_role in [
            "roles/dns.admin"
          ] :
          project_role => [
            "group:terraform@${local.gcp_workspace_domain_name}"
          ]
        }
        projects = [dependency.network_project.outputs.project_id]
      },
      {
        key = "${dependency.network_project.outputs.project_id}-02"
        bindings = {
          for project_role in [
            "roles/editor",
          ] :
          project_role => [
            "group:engineering@${local.gcp_workspace_domain_name}"
          ]
        }
        projects = [dependency.network_project.outputs.project_id]
      }
    ],
    # secret
    [
      {
        key = "${dependency.secret_project.outputs.project_id}-01"
        bindings = {
          for project_role in [
            "roles/secretmanager.admin"
          ] :
          project_role => [
            "group:terraform@${local.gcp_workspace_domain_name}"
          ]
        }
        projects = [dependency.secret_project.outputs.project_id]
      },
      {
        key = "${dependency.secret_project.outputs.project_id}-02"
        bindings = {
          for project_role in [
            "roles/viewer",
          ] :
          project_role => [
            "group:engineering@${local.gcp_workspace_domain_name}"
          ]
        }
        projects = [dependency.secret_project.outputs.project_id]
      }
    ],
  ])
}