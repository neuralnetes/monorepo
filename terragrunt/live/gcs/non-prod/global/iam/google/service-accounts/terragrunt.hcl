terraform {
  source = "github.com/neuralnetes/monorepo.git//terraform/modules/google/service-accounts?ref=main"
}

include {
  path = find_in_parent_folders()
}

dependency "iam_project" {
  config_path = "${get_parent_terragrunt_dir()}/non-prod/global/iam/google/project"
}

dependency "random_string" {
  config_path = "${get_parent_terragrunt_dir()}/non-prod/global/terraform/random/random-string"
}

# test
inputs = {
  service_accounts = [
    for service_account_id in [
      "dex-auth",
      "cert-manager",
      "compute-instance",
      "container-cluster",
      "external-dns",
      "external-secrets",
      "grafana-cloud",
      "kubeflow",
      "openvpn"
    ] :
    {
      project    = dependency.iam_project.outputs.project_id
      account_id = service_account_id
    }
  ]
  service_account_datas = []
}