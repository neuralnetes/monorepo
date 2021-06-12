terraform {
  source = "github.com/neuralnetes/monorepo.git//terraform/modules/google/service-accounts?ref=main"
}

include {
  path = find_in_parent_folders()
}

dependency "iam_project" {
  config_path = "${get_parent_terragrunt_dir()}/non-prod/global/iam/google/project"
}

dependency "terraform_project" {
  config_path = "${get_parent_terragrunt_dir()}/non-prod/global/terraform/google/project"
}

dependency "random_string" {
  config_path = "${get_parent_terragrunt_dir()}/non-prod/global/terraform/random/random-string"
}

locals {
  gcp_workspace_domain_name = get_env("GCP_WORKSPACE_DOMAIN_NAME")
  kubeflow_user_emails      = split(",", get_env("KUBEFLOW_USER_EMAILS"))
  kubeflow_admin_emails     = split(",", get_env("KUBEFLOW_ADMIN_EMAILS"))
  emails = toset(flatten([
    local.kubeflow_user_emails,
    local.kubeflow_admin_emails
  ]))
  service_account_ids = flatten([
    [
      "cert-manager",
      "cloud-sdk",
      "compute-instance",
      "container-cluster",
      "dex-auth",
      "external-dns",
      "external-secrets",
      "grafana-cloud",
      "kubeflow"
    ],
    [
      for email in local.emails :
      replace(
        replace(email, "@${local.gcp_workspace_domain_name}", ""),
        ".",
        "-"
      )
    ]
  ])
}

# test
inputs = {
  service_accounts = [
    for service_account_id in local.service_account_ids :
    {
      project    = dependency.iam_project.outputs.project_id
      account_id = service_account_id
    }
  ]
  service_account_datas = [
    for service_account_id in [
      "terraform"
    ] :
    {
      project    = dependency.terraform_project.outputs.project_id
      account_id = service_account_id
    }
  ]
}