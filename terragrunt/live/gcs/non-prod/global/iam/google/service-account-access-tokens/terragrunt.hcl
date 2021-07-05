terraform {
  source = "github.com/neuralnetes/monorepo.git//terraform/modules/google/service-account-access-tokens?ref=main"
}

include {
  path = find_in_parent_folders()
}

dependency "service_accounts" {
  config_path = "${get_parent_terragrunt_dir()}/non-prod/global/iam/google/service-accounts"
}

inputs = {
  service_account_access_tokens = flatten([
    [
      for service_account_id in [] :
      {
        lifetime               = "1800s"
        target_service_account = dependency.service_accounts.outputs.service_accounts_map[service_account_id].email
        scopes = [
          "https://www.googleapis.com/auth/cloud-platform",
          "https://www.googleapis.com/auth/userinfo.email"
        ]
      }
    ],
    [
      for service_account_id in ["terraform"] :
      {
        lifetime               = "1800s"
        target_service_account = dependency.service_accounts.outputs.service_account_datas_map[service_account_id].email
        scopes = [
          "https://www.googleapis.com/auth/cloud-platform",
          "https://www.googleapis.com/auth/userinfo.email",
          "https://www.googleapis.com/auth/cloud-identity.groups",
          "https://www.googleapis.com/auth/admin.directory.user",
          "https://www.googleapis.com/auth/admin.directory.group"
        ]
      }
    ]
  ])
}
