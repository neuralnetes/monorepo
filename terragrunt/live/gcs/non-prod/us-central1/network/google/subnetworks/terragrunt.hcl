terraform {
  source = "github.com/terraform-google-modules/terraform-google-network.git//modules/subnets-beta?ref=v3.2.1"
}

include {
  path = find_in_parent_folders()
}

dependency "random_string" {
  config_path = "${get_parent_terragrunt_dir()}/non-prod/global/terraform/random/random-string"
}

dependency "vpc" {
  config_path = "${get_parent_terragrunt_dir()}/non-prod/global/network/google/vpc"
}

locals {
  subnet_region = "us-central1"
}

inputs = {
  project_id   = dependency.vpc.outputs.vpc_map["vpc-01"].project_id
  network_name = dependency.vpc.outputs.vpc_map["vpc-01"].network_name
  subnets = [
    {
      subnet_name               = "management-${dependency.random_string.outputs.result}-nodes"
      subnet_ip                 = "10.1.0.0/16"
      subnet_region             = local.subnet_region
      subnet_private_access     = "true"
      subnet_flow_logs          = "true"
      subnet_flow_logs_metadata = "INCLUDE_ALL_METADATA"
      description               = "management-${dependency.random_string.outputs.result}-nodes"
    },
    {
      subnet_name               = "kubeflow-${dependency.random_string.outputs.result}-nodes"
      subnet_ip                 = "10.2.0.0/16"
      subnet_region             = local.subnet_region
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
        ip_cidr_range = "192.168.0.0/18"
      },
      {
        range_name    = "management-${dependency.random_string.outputs.result}-services"
        ip_cidr_range = "192.168.64.0/18"
      },
    ]
    "kubeflow-${dependency.random_string.outputs.result}-nodes" = [
      {
        range_name    = "kubeflow-${dependency.random_string.outputs.result}-pods"
        ip_cidr_range = "192.168.0.0/18"
      },
      {
        range_name    = "kubeflow-${dependency.random_string.outputs.result}-services"
        ip_cidr_range = "192.168.64.0/18"
      },
    ]
  }
}