terraform {
  source = "github.com/neuralnetes/monorepo.git//terraform/modules/google/project-iam-bindings?ref=main"
}

include {
  path = find_in_parent_folders()
}

dependency "dns_project" {
  config_path = "${get_parent_terragrunt_dir()}/non-prod/global/dns/google/project"
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

dependency "service_accounts" {
  config_path = "${get_parent_terragrunt_dir()}/non-prod/global/iam/google/service-accounts"
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

dependency "random_string" {
  config_path = "${get_parent_terragrunt_dir()}/non-prod/global/terraform/random/random-string"
}

dependency "auth" {
  config_path = "${get_parent_terragrunt_dir()}/non-prod/global/terraform/google/auth"
}

locals {
  gcp_workspace_domain_name = get_env("GCP_WORKSPACE_DOMAIN_NAME")
  kubeflow_user_emails      = split(",", get_env("KUBEFLOW_USER_EMAILS"))
}

inputs = {
  project_iam_bindings = [
    # artifact
    {
      name = "${dependency.artifact_project.outputs.project_id}-01"
      bindings = {
        for project_role in [
          "roles/artifactregistry.writer"
        ] :
        project_role => [
          for kubeflow_user_email in local.kubeflow_user_emails :
          "user:${kubeflow_user_email}"
        ]
      }
      project = dependency.artifact_project.outputs.project_id
    },
    # dns
    {
      name = "${dependency.dns_project.outputs.project_id}-01"
      bindings = {
        for project_role in [
          "roles/dns.admin"
        ] :
        project_role => [
          "serviceAccount:${dependency.auth.outputs.email}"
        ]
      }
      project = dependency.dns_project.outputs.project_id
    },
    {
      name = "${dependency.dns_project.outputs.project_id}-02"
      bindings = {
        for project_role in [
          "roles/dns.admin"
        ] :
        project_role => [
          "serviceAccount:${dependency.service_accounts.outputs.service_accounts_map["cert-manager"].email}",
          "serviceAccount:${dependency.service_accounts.outputs.service_accounts_map["external-dns"].email}",
        ]
      }
      project = dependency.dns_project.outputs.project_id
    },
    # kubeflow
    {
      name = "${dependency.kubeflow_project.outputs.project_id}-01"
      bindings = {
        for project_role in [
          "roles/compute.admin"
        ] :
        project_role => [
          "serviceAccount:${dependency.auth.outputs.email}"
        ]
      }
      project = dependency.kubeflow_project.outputs.project_id
    },
    {
      name = "${dependency.kubeflow_project.outputs.project_id}-02"
      bindings = {
        for project_role in [
          "roles/monitoring.viewer"
        ] :
        project_role => [
          "serviceAccount:${dependency.service_accounts.outputs.service_accounts_map["grafana-cloud"].email}"
        ]
      }
      project = dependency.kubeflow_project.outputs.project_id
    },
    {
      name = "${dependency.kubeflow_project.outputs.project_id}-03"
      bindings = {
        for project_role in [
          "roles/logging.logWriter",
          "roles/monitoring.metricWriter",
          "roles/monitoring.viewer",
          "roles/stackdriver.resourceMetadata.writer",
          "roles/storage.objectViewer",
          "roles/artifactregistry.reader"
        ] :
        project_role => [
          "serviceAccount:${dependency.service_accounts.outputs.service_accounts_map["container-cluster"].email}"
        ]
      }
      project = dependency.kubeflow_project.outputs.project_id
    },
    {
      name = "${dependency.kubeflow_project.outputs.project_id}-04"
      bindings = {
        for project_role in [
          "roles/container.admin"
        ] :
        project_role => [
          for kubeflow_user_email in local.kubeflow_user_emails :
          "user:${kubeflow_user_email}"
        ]
      }
      project = dependency.kubeflow_project.outputs.project_id
    },
    # compute
    {
      name = "${dependency.compute_project.outputs.project_id}-01"
      bindings = {
        for project_role in [
          "roles/compute.admin"
        ] :
        project_role => [
          "serviceAccount:${dependency.auth.outputs.email}"
        ]
      }
      project = dependency.compute_project.outputs.project_id
    },
    {
      name = "${dependency.compute_project.outputs.project_id}-02"
      bindings = {
        for project_role in [
          "roles/monitoring.viewer"
        ] :
        project_role => [
          "serviceAccount:${dependency.service_accounts.outputs.service_accounts_map["grafana-cloud"].email}"
        ]
      }
      project = dependency.compute_project.outputs.project_id
    },
    {
      name = "${dependency.compute_project.outputs.project_id}-03"
      bindings = {
        for project_role in [
          "roles/viewer"
        ] :
        project_role => [
          "serviceAccount:${dependency.service_accounts.outputs.service_accounts_map["compute-instance"].email}"
        ]
      }
      project = dependency.compute_project.outputs.project_id
    },
    {
      name = "${dependency.compute_project.outputs.project_id}-04"
      bindings = {
        for project_role in [
          "roles/container.admin"
        ] :
        project_role => [
          for kubeflow_user_email in local.kubeflow_user_emails :
          "user:${kubeflow_user_email}"
        ]
      }
      project = dependency.compute_project.outputs.project_id
    },
    # data
    {
      name = "${dependency.data_project.outputs.project_id}-02"
      bindings = {
        for project_role in [
          "roles/cloudsql.client",
          "roles/storage.admin",
        ] :
        project_role => [
          "serviceAccount:${dependency.service_accounts.outputs.service_accounts_map["kubeflow"].email}",
        ]
      }
      project = dependency.data_project.outputs.project_id
    },
    # iam
    # network
    {
      name = "${dependency.network_project.outputs.project_id}-03"
      bindings = {
        for project_role in [
          "roles/dns.admin"
        ] :
        project_role => [
          "serviceAccount:${dependency.service_accounts.outputs.service_accounts_map["cert-manager"].email}",
          "serviceAccount:${dependency.service_accounts.outputs.service_accounts_map["external-dns"].email}"
        ]
      }
      project = dependency.network_project.outputs.project_id
    },
    # secret
    {
      name = "${dependency.secret_project.outputs.project_id}-02"
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