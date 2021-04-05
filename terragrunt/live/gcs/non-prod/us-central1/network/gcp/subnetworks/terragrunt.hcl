terraform {
  source = "github.com/terraform-google-modules/terraform-google-network.git//modules/subnets-beta?ref=v3.0.0"
}

include {
  path = find_in_parent_folders()
}

dependency "vpc" {
  config_path = "${get_parent_terragrunt_dir()}/non-prod/global/network/gcp/vpc"
}

dependency "random_string" {
  config_path = "${get_parent_terragrunt_dir()}/non-prod/global/terraform/random/random-string"
}

locals {
  cidr_block                  = "10.0.0.0/16"
  cidr_subnetwork_width_delta = 4
  cidr_subnetwork_spacing     = 0

  secondary_cidr_block                  = "10.1.0.0/16"
  secondary_cidr_subnetwork_width_delta = 4
  secondary_cidr_subnetwork_spacing     = 0

  subnet_region = "us-central1"
}

inputs = {
  project_id   = dependency.vpc.outputs.project_id
  network_name = dependency.vpc.outputs.network_name
  subnets = [
    {
      subnet_name = "cluster-${dependency.random_string.outputs.result}"
      subnet_ip = cidrsubnet(
        local.cidr_block,
        local.cidr_subnetwork_width_delta,
        0
      )
      subnet_region             = local.subnet_region
      subnet_private_access     = "true"
      subnet_flow_logs          = "true"
      subnet_flow_logs_metadata = "INCLUDE_ALL_METADATA"
      description               = "cluster-${dependency.random_string.outputs.result}"
    },
    {
      subnet_name = "cloud-sql-${dependency.random_string.outputs.result}"
      subnet_ip = cidrsubnet(
        local.cidr_block,
        local.cidr_subnetwork_width_delta,
        1 * (1 + local.cidr_subnetwork_spacing)
      )
      subnet_region             = local.subnet_region
      subnet_private_access     = "true"
      subnet_flow_logs          = "true"
      subnet_flow_logs_metadata = "INCLUDE_ALL_METADATA"
      subnet_private_access = "true"
      description               = "cloud-sql-${dependency.random_string.outputs.result}"
    },
    {
      subnet_name = "dataflow-${dependency.random_string.outputs.result}"
      subnet_ip = cidrsubnet(
        local.cidr_block,
        local.cidr_subnetwork_width_delta,
        2 * (1 + local.cidr_subnetwork_spacing)
      )
      subnet_region             = local.subnet_region
      subnet_private_access     = "true"
      subnet_flow_logs          = "true"
      subnet_flow_logs_metadata = "INCLUDE_ALL_METADATA"
      description               = "dataflow-${dependency.random_string.outputs.result}"
    },
  ]
  secondary_ranges = {
    "cluster-${dependency.random_string.outputs.result}" = [
      {
        range_name = "cluster-${dependency.random_string.outputs.result}-secondary-01"
        ip_cidr_range = cidrsubnet(
          local.secondary_cidr_block,
          local.secondary_cidr_subnetwork_width_delta,
          0
        )
      },
      {
        range_name = "cluster-${dependency.random_string.outputs.result}-secondary-02"
        ip_cidr_range = cidrsubnet(
          local.secondary_cidr_block,
          local.secondary_cidr_subnetwork_width_delta,
          1 * (1 + local.secondary_cidr_subnetwork_spacing)
        )
      }
    ]
    "cloud-sql-${dependency.random_string.outputs.result}" = [
      {
        range_name = "cloud-sql-${dependency.random_string.outputs.result}-secondary-01"
        ip_cidr_range = cidrsubnet(
          local.secondary_cidr_block,
          local.secondary_cidr_subnetwork_width_delta,
          2 * (1 + local.secondary_cidr_subnetwork_spacing)
        )
      }
    ]
    "dataflow-${dependency.random_string.outputs.result}" = [
      {
        range_name = "dataflow-${dependency.random_string.outputs.result}-secondary-01"
        ip_cidr_range = cidrsubnet(
          local.secondary_cidr_block,
          local.secondary_cidr_subnetwork_width_delta,
          3 * (1 + local.secondary_cidr_subnetwork_spacing)
        )
      }
    ]
  }
}