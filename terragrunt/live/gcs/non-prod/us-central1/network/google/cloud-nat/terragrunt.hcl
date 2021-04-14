terraform {
  source = "github.com/terraform-google-modules/terraform-google-cloud-nat.git//?ref=v1.3.0"
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

dependency "cloud_router" {
  config_path = "${get_parent_terragrunt_dir()}/non-prod/us-central1/network/google/cloud-router"
}

dependency "subnetworks" {
  config_path = "${get_parent_terragrunt_dir()}/non-prod/us-central1/network/google/subnetworks"
}

dependency "random_string" {
  config_path = "${get_parent_terragrunt_dir()}/non-prod/global/terraform/random/random-string"
}

inputs = {
  project_id                         = dependency.vpc.outputs.project_id
  router                             = dependency.cloud_router.outputs.router["name"]
  source_subnetwork_ip_ranges_to_nat = "LIST_OF_SUBNETWORKS"
  subnetworks = [
    {
      name                    = dependency.subnetworks.outputs.subnets["us-central1/cluster-${dependency.random_string.outputs.result}"].id,
      source_ip_ranges_to_nat = ["ALL_IP_RANGES"]
      secondary_ip_range_names = [
        dependency.subnetworks.outputs.subnets["us-central1/cluster-${dependency.random_string.outputs.result}"].secondary_ip_range[0].range_name,
        dependency.subnetworks.outputs.subnets["us-central1/cluster-${dependency.random_string.outputs.result}"].secondary_ip_range[1].range_name
      ]
    }
  ]
}