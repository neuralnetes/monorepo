terraform {
  source = "github.com/neuralnetes/monorepo.git//terraform/modules/google/cloud-dns?ref=main"
}

include {
  path = find_in_parent_folders()
}

dependency "dns_project" {
  config_path = "${get_parent_terragrunt_dir()}/non-prod/global/dns/google/project"
}

dependency "random_string" {
  config_path = "${get_parent_terragrunt_dir()}/shared/global/shared/random/random-string"
}

locals {
  gcp_workspace_domain_name = get_env("GCP_WORKSPACE_DOMAIN_NAME")
}

inputs = {
  cloud_dns = flatten([
    for domain in [
      "dev.n9s.mx",
      "dev.neuralnetes.com",
      "kubeflow-${dependency.random_string.outputs.result}.n9s.mx",
      "kubeflow-${dependency.random_string.outputs.result}.neuralnetes.com",
      "management-${dependency.random_string.outputs.result}.n9s.mx",
      "management-${dependency.random_string.outputs.result}.neuralnetes.com",
      "staging.n9s.mx",
    ] :
    [
      for type in ["public"] :
      {
        project_id                         = dependency.dns_project.outputs.project_id
        type                               = type
        name                               = "${type}-${replace(domain, ".", "-")}"
        domain                             = "${domain}."
        private_visibility_config_networks = []
        recordsets = [
          {
            name = ""
            type = "CAA"
            ttl  = 300
            records = [
              "0 issue \"letsencrypt.org\"",
              "0 issue \"pki.goog\""
            ]
          }
        ]
      }
    ]
  ])
}
