terraform {
  source = "github.com/neuralnetes/monorepo.git//terraform/modules/google/project-iam-bindings?ref=main"
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

dependency "random_string" {
  config_path = "${get_parent_terragrunt_dir()}/non-prod/global/terraform/random/random-string"
}

dependency "auth" {
  config_path = "${get_parent_terragrunt_dir()}/non-prod/global/terraform/google/auth"
}

locals {
  gcp_workspace_domain_name = get_env("GCP_WORKSPACE_DOMAIN_NAME")
}

inputs = {
  project_iam_bindings = [
    # compute
    {
      bindings = {
        for project_role in [
          "roles/compute.admin",
          "roles/iam.serviceAccountAdmin",
        ] :
        project_role => [
          "group:terraform@${local.gcp_workspace_domain_name}"
        ]
      }
      project = dependency.compute_project.outputs.project_id
    },
    {
      bindings = {
        for project_role in [
          "roles/viewer",
        ] :
        project_role => [
          "group:engineering@${local.gcp_workspace_domain_name}"
        ]
      }
      project = dependency.compute_project.outputs.project_id
    },
    {
      bindings = {
        for project_role in [
          "roles/logging.logWriter",
          "roles/monitoring.metricWriter",
          "roles/monitoring.viewer",
          "roles/stackdriver.resourceMetadata.writer",
          "roles/storage.objectViewer",
          "roles/artifactregistry.reader",
        ] :
        project_role => [
          "serviceAccount:${dependency.service_accounts.outputs.service_accounts_map["cluster-${dependency.random_string.outputs.result}"].email}"
        ]
      }
      project = dependency.compute_project.outputs.project_id
    },
    # data
    {
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
      project = dependency.data_project.outputs.project_id
    },
    {
      bindings = {
        for project_role in [
          "roles/viewer",
        ] :
        project_role => [
          "group:engineering@${local.gcp_workspace_domain_name}"
        ]
      }
      project = dependency.data_project.outputs.project_id
    },
    # iam
    {
      bindings = {
        for project_role in [
          "roles/iam.serviceAccountAdmin",
          "roles/iam.serviceAccountKeyAdmin",
        ] :
        project_role => [
          "group:terraform@${local.gcp_workspace_domain_name}"
        ]
      }
      project = dependency.iam_project.outputs.project_id
    },
    {
      bindings = {
        for project_role in [
          "roles/viewer",
        ] :
        project_role => [
          "group:engineering@${local.gcp_workspace_domain_name}"
        ]
      }
      project = dependency.iam_project.outputs.project_id
    },
    # network
    {
      bindings = {
        for project_role in [
          "roles/dns.admin"
        ] :
        project_role => [
          "group:terraform@${local.gcp_workspace_domain_name}"
        ]
      }
      project = dependency.network_project.outputs.project_id
    },
    {
      bindings = {
        for project_role in [
          "roles/viewer",
        ] :
        project_role => [
          "group:engineering@${local.gcp_workspace_domain_name}"
        ]
      }
      project = dependency.network_project.outputs.project_id
    },
    {
      bindings = {
        for project_role in [
          "roles/dns.admin"
        ] :
        project_role => [
          "serviceAccount:${dependency.service_accounts.outputs.service_accounts_map["external-dns"].email}"
        ]
      }
      project = dependency.network_project.outputs.project_id
    },
    {
      bindings = {
        for project_role in [
          "roles/dns.admin"
        ] :
        project_role => [
          "serviceAccount:${dependency.service_accounts.outputs.service_accounts_map["cert-manager"].email}"
        ]
      }
      project = dependency.network_project.outputs.project_id
    },
    # secret
    {
      bindings = {
        for project_role in [
          "roles/secretmanager.admin"
        ] :
        project_role => [
          "group:terraform@${local.gcp_workspace_domain_name}"
        ]
      }
      project = dependency.secret_project.outputs.project_id
    },
    {
      bindings = {
        for project_role in [
          "roles/viewer"
        ] :
        project_role => [
          "group:engineering@${local.gcp_workspace_domain_name}"
        ]
      }
      project = dependency.secret_project.outputs.project_id
    },
    {
      bindings = {
        for project_role in [
          "roles/secretmanager.admin"
        ] :
        project_role => [
          "serviceAccount:${dependency.service_accounts.outputs.service_accounts_map["external-secrets"].email}"
        ]
      }
      project = dependency.secret_project.outputs.project_id
    }
  ]
}