terraform {
  source = "github.com/neuralnetes/monorepo.git//terraform/modules/gcp/cloud-sqls?ref=main"
}

include {
  path = find_in_parent_folders()
}

dependency "data_project" {
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

dependency "compute_addresses" {
  config_path = "${get_parent_terragrunt_dir()}/non-prod/us-central1/network/gcp/compute-addresses"
}

dependency "random_string" {
  config_path = "${get_parent_terragrunt_dir()}/non-prod/global/terraform/random/random-string"
}

locals {
  region = "us-central1"
  zone   = "us-central1-a"
}
resource "google_sql_database_instance" "instance" {
  provider = google-beta

  name   = "private-instance-${random_id.db_name_suffix.hex}"
  region = "us-central1"

  depends_on = [google_service_networking_connection.private_vpc_connection]

  settings {
    tier = "db-f1-micro"
    ip_configuration {
      ipv4_enabled    = false
      private_network = google_compute_network.private_network.id
    }
  }
}
inputs = {
  mysqls = [
    {
      database_version                 = "MYSQL_8_0"
      name                             = "mysql-${dependency.random_string.outputs.result}"
      project_id                       = dependency.data_project.outputs.project_id
      region                           = local.region
      zone                             = local.zone
      tier                             = string
      region                           = string
      database_version                 = string
      ip_configuration_private_network = string
      ip_configuration_ipv4_enabled    = string
      ip_configuration_authorized_networks = list(object({
        value = string
        name  = string
      }))
      ip_configuration_require_ssl = string
      ip_configuration = {
        authorized_networks = [
          {
            name  = "${dependency.subnetworks.outputs.subnets["us-central1/cluster-${dependency.random_string.outputs.result}"]}-01"
            value = dependency.subnetworks.outputs.subnets["us-central1/cluster-${dependency.random_string.outputs.result}"].ip_cidr_range
          },
          {
            name  = "${dependency.subnetworks.outputs.subnets["us-central1/cluster-${dependency.random_string.outputs.result}"]}-02"
            value = dependency.subnetworks.outputs.subnets["us-central1/cluster-${dependency.random_string.outputs.result}"].secondary_ip_range[0].ip_cidr_range,
          },
          {
            name  = "${dependency.subnetworks.outputs.subnets["us-central1/cluster-${dependency.random_string.outputs.result}"]}-03"
            value = dependency.subnetworks.outputs.subnets["us-central1/cluster-${dependency.random_string.outputs.result}"].secondary_ip_range[1].ip_cidr_range,
          },
          {
            name  = "${dependency.subnetworks.outputs.subnets["us-central1/dataflow-${dependency.random_string.outputs.result}"]}-01"
            value = dependency.subnetworks.outputs.subnets["us-central1/dataflow-${dependency.random_string.outputs.result}"].ip_cidr_range,
          },
          {
            name  = "${dependency.subnetworks.outputs.subnets["us-central1/dataflow-${dependency.random_string.outputs.result}"]}-02"
            value = dependency.subnetworks.outputs.subnets["us-central1/dataflow-${dependency.random_string.outputs.result}"].secondary_ip_range[0].ip_cidr_range,
          }
        ]
        ipv4_enabled    = true
        private_network = dependency.vpc.outputs.network_self_link
        require_ssl     = true
      }
    }
  ]
}