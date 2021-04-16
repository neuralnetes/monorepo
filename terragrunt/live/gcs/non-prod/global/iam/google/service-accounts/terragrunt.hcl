terraform {
  source = "github.com/neuralnetes/monorepo.git//terraform/modules/google/service-accounts?ref=main"
}

include {
  path = find_in_parent_folders()
}

dependency "iam_project" {
  config_path = "${get_parent_terragrunt_dir()}/non-prod/global/iam/google/project"
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

inputs = {
  service_accounts = flatten([
    # compute
    [
      {
        project_id = dependency.iam_project.outputs.project_id
        name       = "cluster-${dependency.random_string.outputs.result}"
        project_roles = [
          "${dependency.compute_project.outputs.project_id}=>roles/logging.logWriter",
          "${dependency.compute_project.outputs.project_id}=>roles/monitoring.metricWriter",
          "${dependency.compute_project.outputs.project_id}=>roles/monitoring.viewer",
          "${dependency.compute_project.outputs.project_id}=>roles/stackdriver.resourceMetadata.writer",
          "${dependency.compute_project.outputs.project_id}=>roles/storage.objectViewer",
          "${dependency.compute_project.outputs.project_id}=>roles/artifactregistry.reader",
          "${dependency.iam_project.outputs.project_id}=>roles/iam.serviceAccountUser",
        ]
      },
      {
        project_id = dependency.iam_project.outputs.project_id
        name       = "cert-manager-${dependency.random_string.outputs.result}"
        project_roles = [
          "${dependency.network_project.outputs.project_id}=>roles/dns.admin"
        ]
      },
      {
        project_id = dependency.iam_project.outputs.project_id
        name       = "external-dns-${dependency.random_string.outputs.result}"
        project_roles = [
          "${dependency.network_project.outputs.project_id}=>roles/dns.admin",
        ]
      },
      {
        project_id = dependency.iam_project.outputs.project_id
        name       = "external-secrets-${dependency.random_string.outputs.result}"
        project_roles = [
          "${dependency.secret_project.outputs.project_id}=>roles/secretmanager.admin"
        ]
      },
      {
        project_id = dependency.iam_project.outputs.project_id
        name       = "kubeflow-${dependency.random_string.outputs.result}"
        project_roles = [
          "${dependency.data_project.outputs.project_id}=>roles/storage.admin",
          "${dependency.compute_project.outputs.project_id}=>roles/compute.admin"
        ]
      },
    ]
  ])
}