terraform {
  source = "github.com/neuralnetes/monorepo.git//terraform/modules/google/workload-identity-users?ref=main"
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

dependency "project_iam_bindings" {
  config_path = "${get_parent_terragrunt_dir()}/non-prod/global/iam/google/project-iam-bindings"
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

dependency "container_clusters" {
  config_path = "${get_parent_terragrunt_dir()}/non-prod/us-central1/compute/google/container-clusters"
}

locals {
  kubeflow_kubernetes_service_accounts = [
    "admission-webhook-service-account",
    "argo",
    "centraldashboard",
    "default",
    "jupyter-web-app-service-account",
    "kubeflow-pipelines-cache",
    "kubeflow-pipelines-cache-deployer-sa",
    "kubeflow-pipelines-container-builder",
    "kubeflow-pipelines-metadata-writer",
    "kubeflow-pipelines-viewer",
    "meta-controller-service",
    "metadata-grpc-server",
    "ml-pipeline",
    "ml-pipeline-persistenceagent",
    "ml-pipeline-scheduledworkflow",
    "ml-pipeline-ui",
    "ml-pipeline-viewer-crd-service-account",
    "ml-pipeline-visualizationserver",
    "mpi-operator",
    "mxnet-operator",
    "mysql",
    "pipeline-runner",
    "pytorch-operator",
    "tensorboards-web-app-service-account",
    "tf-job-operator",
    "volumes-web-app-service-account",
    "xgboost-operator-service-account"
  ]
}

inputs = {
  workload_identity_users = flatten([
    [
      {
        project_id                 = dependency.compute_project.outputs.project_id
        service_account_id         = dependency.service_accounts.outputs.service_accounts_map["cert-manager"].email
        kubernetes_namespace       = "cert-manager"
        kubernetes_service_account = "cert-manager"
      },
      {
        project_id                 = dependency.compute_project.outputs.project_id
        service_account_id         = dependency.service_accounts.outputs.service_accounts_map["external-dns"].email
        kubernetes_namespace       = "external-dns"
        kubernetes_service_account = "external-dns"
      },
      {
        project_id                 = dependency.compute_project.outputs.project_id
        service_account_id         = dependency.service_accounts.outputs.service_accounts_map["external-secrets"].email
        kubernetes_namespace       = "external-secrets"
        kubernetes_service_account = "external-secrets"
      }
    ],
    [
      for kubernetes_service_account in local.kubeflow_kubernetes_service_accounts :
      {
        project_id                 = dependency.compute_project.outputs.project_id
        service_account_id         = dependency.service_accounts.outputs.service_accounts_map["kubeflow"].email
        kubernetes_namespace       = "kubeflow"
        kubernetes_service_account = kubernetes_service_account
      }
    ]
  ])
}
