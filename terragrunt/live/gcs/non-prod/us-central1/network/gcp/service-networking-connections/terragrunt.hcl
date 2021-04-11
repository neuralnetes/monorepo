terraform {
  source = "github.com/neuralnetes/monorepo.git//terraform/modules/gcp/service-networking-connections?ref=main"
}

include {
  path = find_in_parent_folders()
}

dependency "vpc" {
  config_path = "${get_parent_terragrunt_dir()}/non-prod/global/network/gcp/vpc"
}

dependency "compute_addresses" {
  config_path = "${get_parent_terragrunt_dir()}/non-prod/us-central1/network/gcp/compute-addresses"
}

dependency "random_string" {
  config_path = "${get_parent_terragrunt_dir()}/non-prod/global/terraform/random/random-string"
}

inputs = {
  service_networking_connections = [
    {
      network = dependency.vpc.outputs.network["id"]
      service = "servicenetworking.googleapis.com"
      reserved_peering_ranges = [
        dependency.compute_addresses.outputs.regional_addresses_map["private-${dependency.vpc.outputs.network["name"]}-01"].name
      ]
    }
  ]
}