terraform {
  source = "github.com/neuralnetes/monorepo.git//terraform/modules/google/cloud-sqls?ref=main"
}

include {
  path = find_in_parent_folders()
}

dependency "data_project" {
  config_path = "${get_parent_terragrunt_dir()}/non-prod/global/data/google/project"
}

dependency "service_project_subnetworks" {
  config_path = "${get_parent_terragrunt_dir()}/non-prod/us-central1/data/google/service-project-subnetworks"
}

dependency "vpc" {
  config_path = "${get_parent_terragrunt_dir()}/non-prod/global/network/google/vpc"
}

dependency "compute_addresses" {
  config_path = "${get_parent_terragrunt_dir()}/non-prod/global/network/google/compute-addresses"
}

dependency "service_networking_connections" {
  config_path = "${get_parent_terragrunt_dir()}/non-prod/global/network/google/service-networking-connections"
}

dependency "random_string" {
  config_path = "${get_parent_terragrunt_dir()}/shared/global/shared/random/random-string"
}

locals {
  region = "us-central1"
  zone   = "us-central1-a"
}

inputs = {
  mysqls = [
    {
      database_version                     = "MYSQL_8_0"
      name                                 = "kubeflow-${dependency.random_string.outputs.result}-mssql-01"
      project_id                           = dependency.data_project.outputs.project_id
      region                               = local.region
      tier                                 = "db-f1-micro"
      zone                                 = local.zone
      ip_configuration_private_network     = dependency.vpc.outputs.vpc_map["vpc-01"].network["id"]
      ip_configuration_ipv4_enabled        = true
      ip_configuration_authorized_networks = []
      ip_configuration_require_ssl         = false
    }
  ]
}