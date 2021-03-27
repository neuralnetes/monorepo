terraform {
  source = "git::git@github.com:neuralnetes/monorepo.git//terraform/modules/gcp/cloud-sqls?ref=main"
}

include {
  path = find_in_parent_folders()
}

dependency "project" {
  config_path = "${get_parent_terragrunt_dir()}/non-prod/global/data/gcp/project"
}

dependency "service_accounts" {
  config_path = "${get_parent_terragrunt_dir()}/non-prod/global/iam/gcp/service-accounts"
}

dependency "vpc" {
  config_path = "${get_parent_terragrunt_dir()}/non-prod/global/network/gcp/vpc"
}

dependency "subnetworks" {
  config_path = "${get_parent_terragrunt_dir()}/non-prod/us-central1/network/gcp/subnetworks"
}

dependency "firewall" {
  config_path = "${get_parent_terragrunt_dir()}/non-prod/us-central1/network/gcp/firewall"
}

dependency "random_string" {
  config_path = "${get_parent_terragrunt_dir()}/non-prod/global/shared/random/random-string"
}

locals {
  region = "us-central1"
  zone   = "us-central1-a"
}

inputs = {
  mysqls = [
    {
      database_version = "MYSQL_8_0"
      name             = "mysql-${dependency.random_string.outputs.result}"
      project_id       = dependency.random_string.outputs.result
      region           = local.region
      zone             = local.zone
      ip_configuration = {
        authorized_networks = []
        ipv4_enabled        = false
        private_network     = dependency.vpc.outputs.network_self_link
        require_ssl         = true
      }
    }
  ]
}