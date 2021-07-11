terraform {
  source = "github.com/neuralnetes/monorepo.git//terraform/modules/google/service-account-keys?ref=main"
}

include {
  path = find_in_parent_folders()
}

dependency "service_accounts" {
  config_path = "${get_parent_terragrunt_dir()}/non-prod/global/iam/google/service-accounts"
}

inputs = {
  service_account_keys = [
    for service_account_id in ["auth", "cert-manager", "grafana"] :
    {
      service_account_id = dependency.service_accounts.outputs.service_accounts_map[service_account_id].email
    }
  ]
}
