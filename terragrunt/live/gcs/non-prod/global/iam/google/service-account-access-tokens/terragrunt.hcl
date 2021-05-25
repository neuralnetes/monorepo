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
  service_account_access_tokens = [
    for service_account_name, service_account in dependency.service_accounts.outputs.service_accounts_map :
    {

      lifetime               = "1800s"
      target_service_account = service_account.email
      scopes                 = ["userinfo-email", "cloud-platform"]
    }
  ]
}
