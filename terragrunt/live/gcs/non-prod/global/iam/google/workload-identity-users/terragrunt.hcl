terraform {
  source = "github.com/neuralnetes/monorepo.git//terraform/modules/google/workload-identity-users?ref=main"
}

include {
  path = find_in_parent_folders()
}

dependency "service_accounts" {
  config_path = "${get_parent_terragrunt_dir()}/non-prod/global/iam/google/service-accounts"
}

dependency "kubeflow_project" {
  config_path = "${get_parent_terragrunt_dir()}/non-prod/global/kubeflow/google/project"
}

dependency "management_project" {
  config_path = "${get_parent_terragrunt_dir()}/non-prod/global/management/google/project"
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
  config_path = "${get_parent_terragrunt_dir()}/shared/global/shared/random/random-string"
}

dependency "container_clusters" {
  config_path = "${get_parent_terragrunt_dir()}/non-prod/us-central1/kubeflow/google/container-clusters"
}

locals {
  gcp_workspace_domain_name = get_env("GCP_WORKSPACE_DOMAIN_NAME")
  workload_identity_users_map = {
    cert-manager = {
      kubernetes_namespace = "cert-manager"
      kubernetes_service_accounts = [
        "cert-manager"
      ]
    }
    external-dns = {
      kubernetes_namespace = "external-dns"
      kubernetes_service_accounts = [
        "external-dns"
      ]
    }
    external-secrets = {
      kubernetes_namespace = "external-secrets"
      kubernetes_service_accounts = [
        "external-secrets"
      ]
    }
    kubeflow = {
      kubernetes_namespace = "kubeflow"
      kubernetes_service_accounts = [
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
    dex-auth = {
      kubernetes_namespace = "auth"
      kubernetes_service_accounts = [
        "dex"
      ]
    }
    cloud-sdk = {
      kubernetes_namespace = "cloud-sdk"
      kubernetes_service_accounts = [
        "cloud-sdk"
      ]
    }
  }
  kubeflow_admin_emails = split(",", get_env("KUBEFLOW_ADMIN_EMAILS"))
  kubeflow_user_emails  = split(",", get_env("KUBEFLOW_USER_EMAILS"))
  emails = toset(flatten([
    local.kubeflow_user_emails,
    local.kubeflow_admin_emails
  ]))
  service_account_ids_map = {
    for email in local.emails :
    email => replace(
      split("@", email)[0],
      ".",
      "-"
    )
  }
}

inputs = {
  workload_identity_users = flatten([
    [
      for service_account_id, workload_identity_user in local.workload_identity_users_map :
      [
        for kubernetes_service_account in workload_identity_user["kubernetes_service_accounts"] :
        {
          project_id                 = dependency.kubeflow_project.outputs.project_id
          service_account_id         = dependency.service_accounts.outputs.service_accounts_map[service_account_id].email
          kubernetes_namespace       = workload_identity_user["kubernetes_namespace"]
          kubernetes_service_account = kubernetes_service_account
        }
      ]
    ],
    [
      for service_account_id, workload_identity_user in local.workload_identity_users_map :
      [
        for kubernetes_service_account in workload_identity_user["kubernetes_service_accounts"] :
        {
          project_id                 = dependency.management_project.outputs.project_id
          service_account_id         = dependency.service_accounts.outputs.service_accounts_map[service_account_id].email
          kubernetes_namespace       = workload_identity_user["kubernetes_namespace"]
          kubernetes_service_account = kubernetes_service_account
        }
      ]
    ],
    [
      for email, service_account_id in local.service_account_ids_map :
      {
        project_id                 = dependency.kubeflow_project.outputs.project_id
        service_account_id         = dependency.service_accounts.outputs.service_accounts_map[service_account_id].email
        kubernetes_namespace       = service_account_id
        kubernetes_service_account = "default-editor"
      }
    ],
    [
      for email, service_account_id in local.service_account_ids_map :
      {
        project_id                 = dependency.management_project.outputs.project_id
        service_account_id         = dependency.service_accounts.outputs.service_accounts_map[service_account_id].email
        kubernetes_namespace       = service_account_id
        kubernetes_service_account = "default-editor"
      }
    ]
  ])
}
