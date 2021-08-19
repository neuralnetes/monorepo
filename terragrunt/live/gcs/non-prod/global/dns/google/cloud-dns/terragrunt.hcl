terraform {
  source = "github.com/neuralnetes/monorepo.git//terraform/modules/google/cloud-dns?ref=main"
}

include {
  path = find_in_parent_folders()
}

dependency "dns_project" {
  config_path = "${get_parent_terragrunt_dir()}/non-prod/global/dns/google/project"
}

locals {
  gcp_workspace_domain_name = get_env("GCP_WORKSPACE_DOMAIN_NAME")
}

inputs = {
  cloud_dns = flatten([
    for domain in [
      "non-prod.n9s.mx",
      "non-prod.neuralnetes.com"
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
