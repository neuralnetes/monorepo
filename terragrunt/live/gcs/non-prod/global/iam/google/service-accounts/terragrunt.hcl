terraform {
  source = "github.com/neuralnetes/monorepo.git//terraform/modules/google/service-accounts?ref=main"
}

include {
  path = find_in_parent_folders()
}

dependency "iam_project" {
  config_path = "${get_parent_terragrunt_dir()}/non-prod/global/iam/google/project"
}

dependency "shared_project" {
  config_path = "${get_parent_terragrunt_dir()}/shared/global/shared/google/project"
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
      "auth",
      "external-dns",
      "external-secrets",
      "grafana",
      "kubeflow"
    ],
    [
      for email in local.emails :
      replace(
        split("@", email)[0],
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
      project    = dependency.shared_project.outputs.project_id
      account_id = service_account_id
    }
  ]
}