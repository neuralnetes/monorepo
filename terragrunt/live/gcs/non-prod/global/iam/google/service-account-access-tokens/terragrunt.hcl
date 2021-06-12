terraform {
  source = "github.com/neuralnetes/monorepo.git//terraform/modules/google/service-account-access-tokens?ref=main"
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

dependency "service_account_iam_bindings" {
  config_path = "${get_parent_terragrunt_dir()}/non-prod/global/iam/google/service-account-iam-bindings"
}

dependency "auth" {
  config_path = "${get_parent_terragrunt_dir()}/non-prod/global/terraform/google/auth"
}

inputs = {
  service_account_access_tokens = flatten([
    [
      for service_account_name in ["compute-instance", "container-cluster"] :
      {

        lifetime               = "1800s"
        target_service_account = dependency.service_accounts.outputs.service_accounts_map[service_account_name].email
        scopes                 = ["userinfo-email", "cloud-platform"]
      }
    ],
    [
      for service_account_name in ["terraform"] :
      {

        lifetime               = "1800s"
        target_service_account = dependency.service_accounts.outputs.service_account_datas_map[service_account_name].email
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
