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
  cidr_block                  = "10.0.0.0/16"
  cidr_subnetwork_width_delta = 4
  cidr_subnetwork_spacing     = 0

  secondary_cidr_block                  = "192.168.0.0/16"
  secondary_cidr_subnetwork_width_delta = 4
  secondary_cidr_subnetwork_spacing     = 0

  subnet_region = "us-central1"
}

inputs = {
  project_id   = dependency.vpc.outputs.vpc_map["vpc-${dependency.random_string.outputs.result}"].project_id
  network_name = dependency.vpc.outputs.vpc_map["vpc-${dependency.random_string.outputs.result}"].network_name
  subnets = [
    {
      subnet_name = "management-${dependency.random_string.outputs.result}-nodes"
      subnet_ip = cidrsubnet(
        local.cidr_block,
        local.cidr_subnetwork_width_delta,
        0 * (1 + local.cidr_subnetwork_spacing)
      )
      subnet_region             = local.subnet_region
      subnet_private_access     = "true"
      subnet_flow_logs          = "true"
      subnet_flow_logs_metadata = "INCLUDE_ALL_METADATA"
      description               = dependency.management_project.outputs.project_id
    },
    {
      subnet_name = "kubeflow-${dependency.random_string.outputs.result}-nodes"
      subnet_ip = cidrsubnet(
        local.cidr_block,
        local.cidr_subnetwork_width_delta,
        1 * (1 + local.cidr_subnetwork_spacing)
      )
      subnet_region             = local.subnet_region
      subnet_private_access     = "true"
      subnet_flow_logs          = "true"
      subnet_flow_logs_metadata = "INCLUDE_ALL_METADATA"
      description               = dependency.kubeflow_project.outputs.project_id
    }
  ]
  secondary_ranges = {
    "management-${dependency.random_string.outputs.result}-nodes" = [
      {
        range_name = "management-${dependency.random_string.outputs.result}-pods"
        ip_cidr_range = cidrsubnet(
          local.secondary_cidr_block,
          local.secondary_cidr_subnetwork_width_delta,
          0 * (1 + local.secondary_cidr_subnetwork_spacing)
        )
      },
      {
        range_name = "management-${dependency.random_string.outputs.result}-services"
        ip_cidr_range = cidrsubnet(
          local.secondary_cidr_block,
          local.secondary_cidr_subnetwork_width_delta,
          1 * (1 + local.secondary_cidr_subnetwork_spacing)
        )
      },
    ]

    "kubeflow-${dependency.random_string.outputs.result}-nodes" = [
      {
        range_name = "kubeflow-${dependency.random_string.outputs.result}-pods"
        ip_cidr_range = cidrsubnet(
          local.secondary_cidr_block,
          local.secondary_cidr_subnetwork_width_delta,
          2 * (1 + local.secondary_cidr_subnetwork_spacing)
        )
      },
      {
        range_name = "kubeflow-${dependency.random_string.outputs.result}-services"
        ip_cidr_range = cidrsubnet(
          local.secondary_cidr_block,
          local.secondary_cidr_subnetwork_width_delta,
          3 * (1 + local.secondary_cidr_subnetwork_spacing)
        )
      },
    ]
  }
}