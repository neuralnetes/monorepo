terraform {
  source = "github.com/terraform-google-modules/terraform-google-vpn.git//?ref=v1.2.0"
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

dependency "subnetworks" {
  config_path = "${get_parent_terragrunt_dir()}/non-prod/us-central1/network/google/subnetworks"
}

dependency "cloud_router" {
  config_path = "${get_parent_terragrunt_dir()}/non-prod/us-central1/network/google/cloud-router"
}

dependency "compute_addresses" {
  config_path = "${get_parent_terragrunt_dir()}/non-prod/global/network/google/compute-addresses"
}

dependency "random_string" {
  config_path = "${get_parent_terragrunt_dir()}/non-prod/global/terraform/random/random-string"
}

inputs = {
  project_id         = dependency.vpc.outputs.project_id
  network            = dependency.vpc.outputs.network["name"]
  region             = "us-central1"
  gateway_name       = "${dependency.vpc.outputs.network["name"]}-vpn"
  tunnel_name_prefix = "${dependency.vpc.outputs.network["name"]}-vpn"
  tunnel_count       = 1
  peer_ips           = ["108.29.73.202"]
  route_priority     = 1000
  remote_subnet      = [dependency.subnetworks.outputs.subnets["us-central1/cluster-${dependency.random_string.outputs.result}"].name]
  cr_enabled         = true
  cr_name            = dependency.cloud_router.outputs.router["name"]
}
