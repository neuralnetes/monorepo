terraform {
  source = "github.com/neuralnetes/monorepo.git//terraform/modules/google/project-iam-bindings?ref=main"
}

include {
  path = find_in_parent_folders()
}

dependency "artifact_project" {
  config_path = "${get_parent_terragrunt_dir()}/non-prod/global/artifact/google/project"
}

dependency "data_project" {
  config_path = "${get_parent_terragrunt_dir()}/non-prod/global/data/google/project"
}

dependency "dns_project" {
  config_path = "${get_parent_terragrunt_dir()}/non-prod/global/dns/google/project"
}

dependency "iam_project" {
  config_path = "${get_parent_terragrunt_dir()}/non-prod/global/iam/google/project"
}

dependency "management_project" {
  config_path = "${get_parent_terragrunt_dir()}/non-prod/global/management/google/project"
}

dependency "kubeflow_project" {
  config_path = "${get_parent_terragrunt_dir()}/non-prod/global/kubeflow/google/project"
}

dependency "network_project" {
  config_path = "${get_parent_terragrunt_dir()}/non-prod/global/network/google/project"
}

dependency "secret_project" {
  config_path = "${get_parent_terragrunt_dir()}/non-prod/global/secret/google/project"
}

dependency "shared_project" {
  config_path = "${get_parent_terragrunt_dir()}/shared/global/shared/google/project"
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
  project_iam_bindings = [
    # dns
    {
      name = "${dependency.dns_project.outputs.project_id}-01"
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
    {
      name = "${dependency.dns_project.outputs.project_id}-02"
      bindings = {
        for project_role in [
          "roles/viewer"
        ] :
        project_role => [
          "serviceAccount:${dependency.service_accounts.outputs.service_accounts_map["grafana"].email}"
        ]
      }
      project = dependency.kubeflow_project.outputs.project_id
    },
    # kubeflow
    {
      name = "${dependency.kubeflow_project.outputs.project_id}-01"
      bindings = {
        for project_role in [
          "roles/viewer",
          "roles/container.admin",
          "roles/serviceusage.serviceUsageAdmin"
        ] :
        project_role => [
          "group:${dependency.identity_groups.outputs.identity_groups_map["kubeflow-admin"].group_key[0].id}"
        ]
      }
      project = dependency.kubeflow_project.outputs.project_id
    },
    {
      name = "${dependency.kubeflow_project.outputs.project_id}-02"
      bindings = {
        for project_role in [
          "roles/viewer",
          "roles/iap.httpsResourceAccessor",
          "roles/container.clusterViewer"
        ] :
        project_role => [
          "group:${dependency.identity_groups.outputs.identity_groups_map["kubeflow-user"].group_key[0].id}"
        ]
      }
      project = dependency.kubeflow_project.outputs.project_id
    },
    {
      name = "${dependency.kubeflow_project.outputs.project_id}-03"
      bindings = {
        for project_role in [
          "roles/viewer"
        ] :
        project_role => [
          "serviceAccount:${dependency.service_accounts.outputs.service_accounts_map["grafana"].email}"
        ]
      }
      project = dependency.kubeflow_project.outputs.project_id
    },
    {
      name = "${dependency.kubeflow_project.outputs.project_id}-04"
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
    # management
    {
      name = "${dependency.management_project.outputs.project_id}-01"
      bindings = {
        for project_role in [
          "roles/viewer",
          "roles/container.admin"
        ] :
        project_role => [
          "group:${dependency.identity_groups.outputs.identity_groups_map["kubeflow-admin"].group_key[0].id}"
        ]
      }
      project = dependency.management_project.outputs.project_id
    },
    {
      name = "${dependency.management_project.outputs.project_id}-02"
      bindings = {
        for project_role in [
          "roles/viewer",
          "roles/iap.httpsResourceAccessor",
          "roles/container.clusterViewer"
        ] :
        project_role => [
          "group:${dependency.identity_groups.outputs.identity_groups_map["kubeflow-user"].group_key[0].id}"
        ]
      }
      project = dependency.management_project.outputs.project_id
    },
    {
      name = "${dependency.management_project.outputs.project_id}-03"
      bindings = {
        for project_role in [
          "roles/viewer"
        ] :
        project_role => [
          "serviceAccount:${dependency.service_accounts.outputs.service_accounts_map["grafana"].email}"
        ]
      }
      project = dependency.management_project.outputs.project_id
    },
    {
      name = "${dependency.management_project.outputs.project_id}-04"
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
      project = dependency.management_project.outputs.project_id
    },
    # data
    {
      name = "${dependency.data_project.outputs.project_id}-01"
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
    {
      name = "${dependency.data_project.outputs.project_id}-02"
      bindings = {
        for project_role in [
          "roles/viewer"
        ] :
        project_role => [
          "serviceAccount:${dependency.service_accounts.outputs.service_accounts_map["grafana"].email}"
        ]
      }
      project = dependency.data_project.outputs.project_id
    },
    # network
    {
      name = "${dependency.network_project.outputs.project_id}-01"
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
    {
      name = "${dependency.network_project.outputs.project_id}-02"
      bindings = {
        for project_role in [
          "roles/viewer"
        ] :
        project_role => [
          "serviceAccount:${dependency.service_accounts.outputs.service_accounts_map["grafana"].email}"
        ]
      }
      project = dependency.network_project.outputs.project_id
    },
    # secret
    {
      name = "${dependency.secret_project.outputs.project_id}-01"
      bindings = {
        for project_role in [
          "roles/secretmanager.admin"
        ] :
        project_role => [
          "serviceAccount:${dependency.service_accounts.outputs.service_accounts_map["external-secrets"].email}",
          "group:${dependency.identity_groups.outputs.identity_groups_map["kubeflow-admin"].group_key[0].id}"
        ]
      }
      project = dependency.secret_project.outputs.project_id
    },
    {
      name = "${dependency.secret_project.outputs.project_id}-02"
      bindings = {
        for project_role in [
          "roles/viewer"
        ] :
        project_role => [
          "serviceAccount:${dependency.service_accounts.outputs.service_accounts_map["grafana"].email}"
        ]
      }
      project = dependency.secret_project.outputs.project_id
    },
  ]
}