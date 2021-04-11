terraform {
  source = "github.com/neuralnetes/monorepo.git//terraform/modules/gcp/service-networking-connections?ref=main"
}

include {
  path = find_in_parent_folders()
}

dependency "project_iam_bindings" {
  config_path = "${get_parent_terragrunt_dir()}/non-prod/global/iam/gcp/project-iam-bindings"
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
        dependency.compute_addresses.outputs.regional_addresses_map["cloud-sql-${dependency.random_string.outputs.result}-01"].name
      ]
    }
  ]
}