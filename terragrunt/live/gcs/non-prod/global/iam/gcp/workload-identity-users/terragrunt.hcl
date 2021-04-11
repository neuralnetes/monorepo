terraform {
  source = "github.com/neuralnetes/monorepo.git//terraform/modules/gcp/workload-identity-users?ref=main"
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

dependency "project_iam_bindings" {
  config_path = "${get_parent_terragrunt_dir()}/non-prod/global/iam/gcp/project-iam-bindings"
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

dependency "container_clusters" {
  config_path = "${get_parent_terragrunt_dir()}/non-prod/us-central1/compute/gcp/container-clusters"
}

//dependency "kustomization" {
//  config_path = "${get_parent_terragrunt_dir()}/non-prod/us-central1/compute/kustomization/deploy"
//}

inputs = {
  workload_identity_users = [
    {
      project_id                 = dependency.iam_project.outputs.project_id
      service_account_id         = dependency.service_accounts.outputs.service_accounts_map["cert-manager-${dependency.random_string.outputs.result}"].unique_id
      kubernetes_namespace       = "cert-manager"
      kubernetes_service_account = "cert-manager"
    },
    {
      project_id                 = dependency.iam_project.outputs.project_id
      service_account_id         = dependency.service_accounts.outputs.service_accounts_map["external-dns-${dependency.random_string.outputs.result}"].unique_id
      kubernetes_namespace       = "external-dns"
      kubernetes_service_account = "external-dns"
    },
    {
      project_id                 = dependency.iam_project.outputs.project_id
      service_account_id         = dependency.service_accounts.outputs.service_accounts_map["kubeflow-${dependency.random_string.outputs.result}"].unique_id
      kubernetes_namespace       = "kubeflow"
      kubernetes_service_account = "kubeflow"
    },
    {
      project_id                 = dependency.iam_project.outputs.project_id
      service_account_id         = dependency.service_accounts.outputs.service_accounts_map["external-secrets-${dependency.random_string.outputs.result}"].unique_id
      kubernetes_namespace       = "external-secrets"
      kubernetes_service_account = "external-secrets"
    }
  ]
}
