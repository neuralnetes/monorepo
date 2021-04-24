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

# test
inputs = {
  service_accounts = [
    {
      project    = dependency.iam_project.outputs.project_id
      account_id = "cert-manager"
    },
    {
      project    = dependency.iam_project.outputs.project_id
      account_id = "external-dns"
    },
    {
      project    = dependency.iam_project.outputs.project_id
      account_id = "external-secrets"
    },
  ]
  service_account_datas = []
}