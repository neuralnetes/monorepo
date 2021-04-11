terraform {
  source = "github.com/neuralnetes/monorepo.git//terraform/modules/gcp/compute-addresses?ref=main"
}

include {
  path = find_in_parent_folders()
}

dependency "vpc" {
  config_path = "${get_parent_terragrunt_dir()}/non-prod/global/network/gcp/vpc"
}

dependency "random_string" {
  config_path = "${get_parent_terragrunt_dir()}/non-prod/global/terraform/random/random-string"
}

inputs = {
  regional_addresses = [
    {
      name          = "private-${dependency.vpc.outputs.network["name"]}-01"
      purpose       = "VPC_PEERING"
      address_type  = "INTERNAL"
      prefix_length = 16
      network       = dependency.vpc.outputs.network["id"]
    }
  ]
  global_addresses = []
}