terraform {
  source = "git::git@github.com:neuralnetes/monorepo.git//terraform/modules/gcp/workload-identity-users?ref=main"
}

include {
  path = find_in_parent_folders()
}

dependency "project" {
  config_path = "${get_parent_terragrunt_dir()}/non-prod/global/compute/gcp/project"
}

dependency "service_accounts" {
  config_path = "${get_parent_terragrunt_dir()}/non-prod/global/compute/gcp/service-accounts"
}

dependency "random_string" {
  config_path = "${get_parent_terragrunt_dir()}/non-prod/global/shared/random/random-string"
}

dependency "container_clusters" {
  config_path = "${get_terragrunt_dir()}/../container-clusters"
}

dependency "kustomization_bootstrap" {
  config_path = "${get_terragrunt_dir()}/../../kustomization/bootstrap"
}

inputs = {
  workload_identity_users = [
    {
      project_id                 = dependency.project.outputs.project_id
      service_account_id         = dependency.service_accounts.outputs.service_accounts_map["cert-manager-${dependency.random_string.outputs.result}"].email
      kubernetes_namespace       = "cert-manager"
      kubernetes_service_account = "cert-manager"
    },
    {
      project_id                 = dependency.project.outputs.project_id
      service_account_id         = dependency.service_accounts.outputs.service_accounts_map["external-dns-${dependency.random_string.outputs.result}"].email
      kubernetes_namespace       = "external-dns"
      kubernetes_service_account = "external-dns"
    },
    {
      project_id                 = dependency.project.outputs.project_id
      service_account_id         = dependency.service_accounts.outputs.service_accounts_map["kubernetes-external-secrets-${dependency.random_string.outputs.result}"].email
      kubernetes_namespace       = "kubernetes-external-secrets"
      kubernetes_service_account = "kubernetes-external-secrets"
    },
    {
      project_id                 = dependency.project.outputs.project_id
      service_account_id         = dependency.service_accounts.outputs.service_accounts_map["minio-${dependency.random_string.outputs.result}"].email
      kubernetes_namespace       = "minio"
      kubernetes_service_account = "minio"
    }
  ]
}
