terraform {
  source = "github.com/terraform-google-modules/terraform-google-network.git//modules/subnets?ref=v3.2.1"
}

include {
  path = find_in_parent_folders()
}

dependency "random_string" {
  config_path = "${get_parent_terragrunt_dir()}/shared/global/shared/random/random-string"
}

dependency "vpc" {
  config_path = "${get_parent_terragrunt_dir()}/non-prod/global/network/google/vpc"
}

locals {
  region = "us-central1"
  # "The difference between your network and subnetwork netmask; an /16 network and a /20 subnetwork would be 4."
  cidr_subnetwork_width_delta = 4
  # "How many subnetwork-mask sized spaces to leave between each subnetwork type.
  cidr_subnetwork_spacing = 0
  # "How many subnetwork-mask sized spaces to leave between each subnetwork type's secondary ranges."
  secondary_cidr_subnetwork_width_delta = 4
  # "How many subnetwork-mask sized spaces to leave between each subnetwork type's secondary ranges."
  secondary_cidr_subnetwork_spacing = 0
}

inputs = {
  project_id   = dependency.vpc.outputs.vpc_map["vpc-01"].project_id
  network_name = dependency.vpc.outputs.vpc_map["vpc-01"].network_name
  subnets = [
    {
      subnet_name               = "management-${dependency.random_string.outputs.result}-nodes"
      subnet_ip                 = cidrsubnet("10.0.0.0/16", local.cidr_subnetwork_width_delta, local.cidr_subnetwork_spacing)
      subnet_region             = local.region
      subnet_private_access     = "true"
      subnet_flow_logs          = "true"
      subnet_flow_logs_metadata = "INCLUDE_ALL_METADATA"
      description               = "management-${dependency.random_string.outputs.result}-nodes"
    },
    {
      subnet_name               = "kubeflow-${dependency.random_string.outputs.result}-nodes"
      subnet_ip                 = cidrsubnet("10.4.0.0/16", local.cidr_subnetwork_width_delta, local.cidr_subnetwork_spacing)
      subnet_region             = local.region
      subnet_private_access     = "true"
      subnet_flow_logs          = "true"
      subnet_flow_logs_metadata = "INCLUDE_ALL_METADATA"
      description               = "kubeflow-${dependency.random_string.outputs.result}-nodes"
    }
  ]
  secondary_ranges = {
    "management-${dependency.random_string.outputs.result}-nodes" = [
      {
        range_name    = "management-${dependency.random_string.outputs.result}-pods"
        ip_cidr_range = cidrsubnet("10.1.0.0/16", local.secondary_cidr_subnetwork_width_delta, local.secondary_cidr_subnetwork_spacing)
      },
      {
        range_name    = "management-${dependency.random_string.outputs.result}-services"
        ip_cidr_range = cidrsubnet("10.2.0.0/16", local.secondary_cidr_subnetwork_width_delta, local.secondary_cidr_subnetwork_spacing)
      },
    ]
    "kubeflow-${dependency.random_string.outputs.result}-nodes" = [
      {
        range_name    = "kubeflow-${dependency.random_string.outputs.result}-pods"
        ip_cidr_range = cidrsubnet("10.5.0.0/16", local.secondary_cidr_subnetwork_width_delta, local.secondary_cidr_subnetwork_spacing)
      },
      {
        range_name    = "kubeflow-${dependency.random_string.outputs.result}-services"
        ip_cidr_range = cidrsubnet("10.6.0.0/16", local.secondary_cidr_subnetwork_width_delta, local.secondary_cidr_subnetwork_spacing)
      },
    ]
  }
}