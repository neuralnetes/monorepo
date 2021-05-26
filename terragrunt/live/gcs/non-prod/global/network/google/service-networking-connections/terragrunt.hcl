terraform {
  source = "github.com/neuralnetes/monorepo.git//terraform/modules/google/service-networking-connections?ref=main"
}

include {
  path = find_in_parent_folders()
}

dependency "project_iam_bindings" {
  config_path = "${get_parent_terragrunt_dir()}/non-prod/global/iam/google/project-iam-bindings"
}

dependency "vpc" {
  config_path = "${get_parent_terragrunt_dir()}/non-prod/global/network/google/vpc"
}

dependency "compute_addresses" {
  config_path = "${get_parent_terragrunt_dir()}/non-prod/global/network/google/compute-addresses"
}

dependency "random_string" {
  config_path = "${get_parent_terragrunt_dir()}/non-prod/global/terraform/random/random-string"
}

inputs = {
  service_networking_connections = [
    {
      network = dependency.vpc.outputs.vpc_map["vpc-${dependency.random_string.outputs.result}"].network["id"]
      service = "servicenetworking.googleapis.com"
      reserved_peering_ranges = [
        dependency.compute_addresses.outputs.global_addresses_map["google-managed-services-global-${dependency.vpc.outputs.vpc_map["vpc-${dependency.random_string.outputs.result}"].network["name"]}"].name
      ]
    }
  ]
}