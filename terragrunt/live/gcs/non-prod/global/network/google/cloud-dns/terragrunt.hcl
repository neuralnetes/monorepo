terraform {
  source = "github.com/neuralnetes/monorepo.git//terraform/modules/google/cloud-dns?ref=main"
}

include {
  path = find_in_parent_folders()
}

dependency "network_project" {
  config_path = "${get_parent_terragrunt_dir()}/non-prod/global/network/google/project"
}

dependency "vpc" {
  config_path = "${get_parent_terragrunt_dir()}/non-prod/global/network/google/vpc"
}

dependency "random_string" {
  config_path = "${get_parent_terragrunt_dir()}/non-prod/global/terraform/random/random-string"
}

locals {
  gsuite_domain_name = get_env("GCP_WORKSPACE_DOMAIN_NAME")
}

inputs = {
  cloud_dns = [
    {
      project_id = dependency.vpc.outputs.project_id
      type       = "private"
      name       = replace("private-${dependency.vpc.outputs.project_id}-${local.gsuite_domain_name}", ".", "-")
      domain     = "${dependency.vpc.outputs.project_id}.${local.gsuite_domain_name}."
      private_visibility_config_networks = [
        dependency.vpc.outputs.network_self_link
      ]
    },
    {
      project_id                         = dependency.vpc.outputs.project_id
      type                               = "public"
      name                               = replace("public-${dependency.vpc.outputs.project_id}-${local.gsuite_domain_name}", ".", "-")
      domain                             = "${dependency.vpc.outputs.project_id}.${local.gsuite_domain_name}."
      private_visibility_config_networks = []
    }
  ]
}