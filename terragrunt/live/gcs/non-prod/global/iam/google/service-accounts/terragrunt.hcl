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
}

# test
inputs = {
  service_accounts = [
    for service_account_id in flatten([
      [
        "dex-auth",
        "cert-manager",
        "cloud-sdk",
        "compute-instance",
        "container-cluster",
        "external-dns",
        "external-secrets",
        "grafana-cloud",
        "kubeflow"
      ],
      [
        for kubeflow_user_email in local.kubeflow_user_emails :
        replace(replace(replace(kubeflow_user_email, local.gcp_workspace_domain_name, ""), "@", ""), ".", "-")
      ]
    ]) :
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