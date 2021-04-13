terraform {
  source = "github.com/neuralnetes/monorepo.git//terraform/modules/google/cloud-sqls?ref=main"
}

include {
  path = find_in_parent_folders()
}

dependency "data_project" {
  config_path = "${get_parent_terragrunt_dir()}/non-prod/global/data/google/project"
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

dependency "firewall_rules" {
  config_path = "${get_parent_terragrunt_dir()}/non-prod/us-central1/network/google/firewall-rules"
}

dependency "compute_addresses" {
  config_path = "${get_parent_terragrunt_dir()}/non-prod/global/network/google/compute-addresses"
}

dependency "service_networking_connections" {
  config_path = "${get_parent_terragrunt_dir()}/non-prod/us-central1/network/google/service-networking-connections"
}

dependency "random_string" {
  config_path = "${get_parent_terragrunt_dir()}/non-prod/global/terraform/random/random-string"
}

locals {
  region = "us-central1"
  zone   = "us-central1-a"
}

inputs = {
  mysqls = [
    {
      database_version                 = "MYSQL_8_0"
      name                             = "cloud-sql-${dependency.random_string.outputs.result}"
      project_id                       = dependency.data_project.outputs.project_id
      region                           = local.region
      tier                             = "db-f1-micro"
      zone                             = local.zone
      ip_configuration_private_network = dependency.vpc.outputs.network["id"]
      ip_configuration_ipv4_enabled    = true
      ip_configuration_authorized_networks = [
        {
          name  = "us-central1/cluster-${dependency.random_string.outputs.result}"
          value = dependency.subnetworks.outputs.subnets["us-central1/cluster-${dependency.random_string.outputs.result}"].ip_cidr_range
        },
        {
          name  = "us-central1/cluster-${dependency.random_string.outputs.result}-pods"
          value = dependency.subnetworks.outputs.subnets["us-central1/cluster-${dependency.random_string.outputs.result}"].secondary_ip_range[0].range_name
        },
        {
          name  = "us-central1/cluster-${dependency.random_string.outputs.result}-services"
          value = dependency.subnetworks.outputs.subnets["us-central1/cluster-${dependency.random_string.outputs.result}"].secondary_ip_range[1].range_name
        },
      ]
      ip_configuration_require_ssl = true
    }
  ]
}