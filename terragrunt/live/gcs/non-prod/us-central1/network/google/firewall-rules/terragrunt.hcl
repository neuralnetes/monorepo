terraform {
  source = "github.com/terraform-google-modules/terraform-google-network.git//modules/firewall-rules?ref=v3.2.1"
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

dependency "random_string" {
  config_path = "${get_parent_terragrunt_dir()}/non-prod/global/terraform/random/random-string"
}

dependency "tags" {
  config_path = "${get_parent_terragrunt_dir()}/non-prod/global/terraform/google/tags"
}

inputs = {
  project_id   = dependency.vpc.outputs.project_id
  network_name = dependency.vpc.outputs.network_name
  rules = [
    {
      name                    = "allow-ingress-public"
      description             = "allow-ingress-public"
      direction               = "INGRESS"
      priority                = 1000
      ranges                  = ["0.0.0.0/0"]
      source_service_accounts = null
      source_tags             = null
      target_service_accounts = null
      target_tags = [
        dependency.tags.outputs.tags_map["public"]
      ]
      allow = [
        {
          protocol = "all"
          ports    = null
        }
      ]
      deny = []
      log_config = {
        metadata = "INCLUDE_ALL_METADATA"
      }
    },
    {
      name        = "allow-ingress-private"
      description = "allow-ingress-private"
      direction   = "INGRESS"
      priority    = 1000
      ranges = [
        "192.168.0.0/28",
        dependency.subnetworks.outputs.subnets["us-central1/cluster-${dependency.random_string.outputs.result}"].ip_cidr_range,
        dependency.subnetworks.outputs.subnets["us-central1/cluster-${dependency.random_string.outputs.result}"].secondary_ip_range[0].ip_cidr_range,
        dependency.subnetworks.outputs.subnets["us-central1/cluster-${dependency.random_string.outputs.result}"].secondary_ip_range[1].ip_cidr_range
      ]
      source_service_accounts = null
      source_tags             = null
      target_service_accounts = null
      target_tags = [
        dependency.tags.outputs.tags_map["private"]
      ]
      allow = [
        {
          protocol = "all"
          ports    = null
        }
      ]
      deny = []
      log_config = {
        metadata = "INCLUDE_ALL_METADATA"
      }
    },
    {
      name                    = "allow-ingress-private-restricted"
      description             = "allow-ingress-private-restricted"
      direction               = "INGRESS"
      priority                = 1000
      ranges                  = null
      source_service_accounts = null
      source_tags = [
        dependency.tags.outputs.tags_map["private"],
        dependency.tags.outputs.tags_map["private_persistence"],
      ]
      target_service_accounts = null
      target_tags = [
        dependency.tags.outputs.tags_map["private"]
      ]
      allow = [
        {
          protocol = "all"
          ports    = null
        }
      ]
      deny = []
      log_config = {
        metadata = "INCLUDE_ALL_METADATA"
      }
    },
    {
      name                    = "allow-ingress-public-restricted"
      description             = "allow-ingress-public-restricted"
      direction               = "INGRESS"
      priority                = 1000
      ranges                  = []
      source_service_accounts = null
      source_tags             = null
      target_service_accounts = null
      target_tags = [
        dependency.tags.outputs.tags_map["public_restricted"]
      ]
      allow = [
        {
          protocol = "all"
          ports    = null
        }
      ]
      deny = []
      log_config = {
        metadata = "INCLUDE_ALL_METADATA"
      }
    }
  ]
}