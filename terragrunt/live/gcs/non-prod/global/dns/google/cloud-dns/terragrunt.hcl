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
  gcp_workspace_domain_name                      = get_env("GCP_WORKSPACE_DOMAIN_NAME")
  gcp_workspace_domain_name_mx_verification_code = get_env("GCP_WORKSPACE_DOMAIN_NAME_MX_VERIFICATION_CODE")
}

inputs = {
  cloud_dns = flatten([
    //    for domain in [
    //      "n9s.mx"
    //    ] :
    //    [
    //      for type in ["public"] :
    //      {
    //        project_id                         = dependency.dns_project.outputs.project_id
    //        type                               = type
    //        name                               = "${type}-${replace(domain, ".", "-")}"
    //        domain                             = "${domain}."
    //        private_visibility_config_networks = []
    //        recordsets = [
    //          {
    //            name = ""
    //            type = "CAA"
    //            ttl  = 300
    //            records = [
    //              "0 issue \"letsencrypt.org\"",
    //              "0 issue \"pki.goog\""
    //            ]
    //          },
    //          {
    //            name = "@"
    //            type = "MX"
    //            ttl  = 3600
    //            records = [
    //              "1 aspmx.l.google.com.",
    //              "5 alt1.l.google.com.",
    //              "5 alt2.l.google.com.",
    //              "10 alt3.l.google.com.",
    //              "10 alt4.l.google.com.",
    //            ],
    //          }
    //        ]
    //      }
    //    ]
  ])
}
