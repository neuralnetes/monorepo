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
  default_group_engineering_bindings = {
    for project_role in [
      "roles/viewer"
    ] :
    project_role => [
      "group:engineering@${local.gcp_workspace_domain_name}"
    ]
  }
}

inputs = {
  project_iam_bindings = [
    # kubeflow
    {
      name     = "${dependency.kubeflow_project.outputs.project_id}-00"
      bindings = local.default_group_engineering_bindings
      project  = dependency.kubeflow_project.outputs.project_id
    },
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
          "group:container-admins@${local.gcp_workspace_domain_name}"
        ]
      }
      project = dependency.kubeflow_project.outputs.project_id
    },
    # compute
    {
      name     = "${dependency.compute_project.outputs.project_id}-00"
      bindings = local.default_group_engineering_bindings
      project  = dependency.compute_project.outputs.project_id
    },
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
          "group:container-admins@${local.gcp_workspace_domain_name}"
        ]
      }
      project = dependency.compute_project.outputs.project_id
    },
    # data
    {
      name     = "${dependency.data_project.outputs.project_id}-00"
      bindings = local.default_group_engineering_bindings
      project  = dependency.data_project.outputs.project_id
    },
    {
      name = "${dependency.data_project.outputs.project_id}-01"
      bindings = {
        for project_role in [
          "roles/cloudsql.admin",
          "roles/storage.admin",
          "roles/bigquery.admin",
          "roles/pubsub.admin",
        ] :
        project_role => [
          "serviceAccount:${dependency.auth.outputs.email}"
        ]
      }
      project = dependency.data_project.outputs.project_id
    },
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
    {
      name     = "${dependency.iam_project.outputs.project_id}-00"
      bindings = local.default_group_engineering_bindings
      project  = dependency.iam_project.outputs.project_id
    },
    {
      name = "${dependency.iam_project.outputs.project_id}-01"
      bindings = {
        for project_role in [
          "roles/iam.serviceAccountAdmin",
          "roles/iam.serviceAccountUser",
          "roles/iam.serviceAccountKeyAdmin",
          "roles/iam.serviceAccountTokenCreator"
        ] :
        project_role => [
          "serviceAccount:${dependency.auth.outputs.email}"
        ]
      }
      project = dependency.iam_project.outputs.project_id
    },
    # network
    {
      name     = "${dependency.network_project.outputs.project_id}-00"
      bindings = local.default_group_engineering_bindings
      project  = dependency.network_project.outputs.project_id
    },
    {
      name = "${dependency.network_project.outputs.project_id}-01"
      bindings = {
        for project_role in [
          "roles/compute.admin",
          "roles/dns.admin"
        ] :
        project_role => [
          "serviceAccount:${dependency.auth.outputs.email}",
        ]
      }
      project = dependency.network_project.outputs.project_id
    },
    {
      name = "${dependency.network_project.outputs.project_id}-02"
      bindings = {
        for project_role in [
          "roles/compute.networkUser"
        ] :
        project_role => [
          "serviceAccount:${dependency.service_accounts.outputs.service_accounts_map["compute-instance"].email}",
          "serviceAccount:${dependency.service_accounts.outputs.service_accounts_map["container-cluster"].email}"
        ]
      }
      project = dependency.network_project.outputs.project_id
    },
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
      name     = "${dependency.secret_project.outputs.project_id}-00"
      bindings = local.default_group_engineering_bindings
      project  = dependency.secret_project.outputs.project_id
    },
    {
      name = "${dependency.secret_project.outputs.project_id}-01"
      bindings = {
        for project_role in [
          "roles/secretmanager.admin"
        ] :
        project_role => [
          "serviceAccount:${dependency.auth.outputs.email}",
        ]
      }
      project = dependency.secret_project.outputs.project_id
    },
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