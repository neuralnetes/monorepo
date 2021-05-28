terraform {
  source = "github.com/neuralnetes/monorepo.git//terraform/modules/google/service-account-keys?ref=main"
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

inputs = {
  service_account_keys = [
    for service_account_name in ["dex-auth", "cert-manager", "grafana-cloud"] :
    {
      service_account_id = dependency.service_accounts.outputs.service_accounts_map[service_account_name].email
    }
  ]
}
