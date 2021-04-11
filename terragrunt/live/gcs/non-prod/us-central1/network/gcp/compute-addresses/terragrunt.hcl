terraform {
  source = "github.com/neuralnetes/monorepo.git//terraform/modules/gcp/compute-addresses?ref=main"
}

include {
  path = find_in_parent_folders()
}

dependency "vpc" {
  config_path = "${get_parent_terragrunt_dir()}/non-prod/global/network/gcp/vpc"
}

dependency "subnetworks" {
  config_path = "${get_parent_terragrunt_dir()}/non-prod/us-central1/network/gcp/subnetworks"
}

dependency "random_string" {
  config_path = "${get_parent_terragrunt_dir()}/non-prod/global/terraform/random/random-string"
}

locals {
  region = "us-central1"
}

inputs = {
  regional_addresses = [
    {
      name         = "mysqls-${dependency.random_string.outputs.result}"
      purpose      = "VPC_PEERING"
      address_type = "INTERNAL"
      subnetwork   = dependency.subnetworks.outputs.subnets["${local.region}/mysqls-${dependency.random_string.outputs.result}"].id
      region       = local.region
    }
  ]
  global_addresses = []
}