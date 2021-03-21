terraform {
  source = "git::git@github.com:neuralnetes/monorepo.git//terraform/modules/gcp/service-accounts?ref=main"
}

include {
  path = find_in_parent_folders()
}

dependency "project" {
  config_path = "${get_terragrunt_dir()}/../project"
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
  config_path = "${get_parent_terragrunt_dir()}/non-prod/global/shared/random/random-string"
}

inputs = {
  service_accounts = [
    {
      project_id = dependency.project.outputs.project_id
      name       = "cert-manager-${dependency.random_string.outputs.result}"
      project_roles = [
        "${dependency.network_project.outputs.project_id}=>roles/dns.admin"
      ]
    },
    {
      project_id = dependency.project.outputs.project_id
      name       = "external-dns-${dependency.random_string.outputs.result}"
      project_roles = [
        "${dependency.network_project.outputs.project_id}=>roles/dns.admin",
      ]
    },
    {
      project_id = dependency.project.outputs.project_id
      name       = "kubernetes-external-secrets-${dependency.random_string.outputs.result}"
      project_roles = [
        "${dependency.secrets_project.outputs.project_id}=>roles/secretmanager.admin"
      ]
    },
    {
      project_id = dependency.project.outputs.project_id
      name       = "minio-${dependency.random_string.outputs.result}"
      project_roles = [
        "${dependency.data_project.outputs.project_id}=>roles/storage.admin"
      ]
    },
    {
      project_id = dependency.project.outputs.project_id
      name       = "-${dependency.random_string.outputs.result}"
      project_roles = [
        "${dependency.data_project.outputs.project_id}=>roles/storage.admin"
      ]
    },
    {
      project_id = dependency.project.outputs.project_id
      name       = "cluster-${dependency.random_string.outputs.result}"
      project_roles = [
        "${dependency.project.outputs.project_id}=>roles/logging.logWriter",
        "${dependency.project.outputs.project_id}=>roles/monitoring.metricWriter",
        "${dependency.project.outputs.project_id}=>roles/monitoring.viewer",
        "${dependency.project.outputs.project_id}=>roles/stackdriver.resourceMetadata.writer",
        "${dependency.project.outputs.project_id}=>roles/storage.objectViewer",
        "${dependency.project.outputs.project_id}=>roles/artifactregistry.reader"
      ]
    },
    {
      project_id = dependency.project.outputs.project_id
      name       = "dataflow-${dependency.random_string.outputs.result}"
      project_roles = [
        "${dependency.project.outputs.project_id}=>roles/dataflow.worker",
        "${dependency.project.outputs.project_id}=>roles/compute.admin",
        "${dependency.data_project.outputs.project_id}=>roles/storage.admin",
        "${dependency.data_project.outputs.project_id}=>roles/pubsub.admin",
        "${dependency.data_project.outputs.project_id}=>roles/bigquery.admin",
      ]
    }
  ]
}