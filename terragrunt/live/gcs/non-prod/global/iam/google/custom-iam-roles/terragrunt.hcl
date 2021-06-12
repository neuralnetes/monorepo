terraform {
  source = "github.com/neuralnetes/monorepo.git//terraform/modules/google/custom-iam-roles?ref=main"
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

dependency "auth" {
  config_path = "${get_parent_terragrunt_dir()}/non-prod/global/terraform/google/auth"
}

locals {
  gcp_workspace_domain_name = get_env("GCP_WORKSPACE_DOMAIN_NAME")
}

inputs = {
  custom_iam_roles = [
    {
      target_level = "project"
      target_id    = dependency.iam_project.outputs.project_id
      role_id      = "clientauthconfig_00"
      title        = "clientauthconfig_00"
      description  = "clientauthconfig_00"
      base_roles   = []
      permissions = [
        "clientauthconfig.brands.create",
        "clientauthconfig.brands.get",
        "clientauthconfig.brands.update",
        "clientauthconfig.clients.create",
        "clientauthconfig.clients.get",
        "clientauthconfig.clients.list",
        "clientauthconfig.clients.update",
        "iam.serviceAccounts.list",
        "oauthconfig.testusers.get",
        "oauthconfig.testusers.update",
        "oauthconfig.verification.get",
        "oauthconfig.verification.update",
        "resourcemanager.projects.get",
        "serviceusage.services.list"
      ]
      excluded_permissions = []
      members              = ["user:alexander.lerma@${local.gcp_workspace_domain_name}"]
    }
  ]
}
