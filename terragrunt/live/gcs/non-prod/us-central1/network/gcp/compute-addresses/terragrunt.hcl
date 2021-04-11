terraform {
  source = "github.com/terraform-google-modules/terraform-google-network.git//modules/fabric-net-firewall?ref=v3.0.0"
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

inputs = {
  regional_addresses = [
    {
      name          = "private-${dependency.vpc.outputs.name}-01"
      purpose       = "VPC_PEERING"
      address_type  = "INTERNAL"
      prefix_length = 16
      network       = dependency.vpc.outputs.id
    }
  ]
  global_addresses = []
}