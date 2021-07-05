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
  config_path = "${get_parent_terragrunt_dir()}/shared/global/shared/random/random-string"
}

inputs = {
  service_networking_connections = [
    {
      network = dependency.vpc.outputs.vpc_map["vpc-01"].network["id"]
      service = "servicenetworking.googleapis.com"
      reserved_peering_ranges = [
        dependency.compute_addresses.outputs.global_addresses_map["global-google-managed-services"].name
      ]
    }
  ]
}