terraform {
  source = "github.com/terraform-google-modules/terraform-google-network.git//modules/fabric-rules?ref=v3.2.0"
}

include {
  path = find_in_parent_folders()
}

dependency "vpc" {
  config_path = "${get_parent_terragrunt_dir()}/non-prod/global/network/gcp/vpc"
}

dependency "subnetworks" {
  config_path = "${get_parent_terragrunt_dir()}/non-prod/us-central1/network/gcp/subnetworks"
}

dependency "random_string" {
  config_path = "${get_parent_terragrunt_dir()}/non-prod/global/terraform/random/random-string"
}

locals {
  public_restricted_allow_network_inbound = {
    description          = "tf managed - public - allow ingress from specific sources"
    direction            = "INGRESS"
    action               = "allow"
    ranges               = local.allowed_public_restricted_subnetworks
    use_service_accounts = false
    targets              = [local.public_restricted]
    sources              = null
    rules = [
      {
        protocol = "all"
        ports    = null
      }
    ]
    extra_attributes = {
      priority = 1000
    }
  }
}

inputs = {
  project_id = dependency.vpc.outputs.project_id
  network    = dependency.vpc.outputs.network_name
  rules = [
      {
        name = "allow-ingress-public"
        direction            = "INGRESS"
        ranges               = ["0.0.0.0/0"]
        target_tags              = [local.public]
        allow = [
          {
            protocol = "all"
            ports    = null
          }
        ]
        log_config = {
          metadata = "INCLUDE_ALL_METADATA"
        }
      },
      {
        name = "allow-ingress-private"
        direction            = "INGRESS"
        ranges = [
          dependency.subnetworks.outputs.subnets["us-central1/cluster-${dependency.random_string.outputs.result}"].ip_cidr_range,
          dependency.subnetworks.outputs.subnets["us-central1/cluster-${dependency.random_string.outputs.result}"].secondary_ip_range[0].ip_cidr_range,
          dependency.subnetworks.outputs.subnets["us-central1/cluster-${dependency.random_string.outputs.result}"].secondary_ip_range[1].ip_cidr_range,
          dependency.subnetworks.outputs.subnets["us-central1/dataflow-${dependency.random_string.outputs.result}"].ip_cidr_range,
          dependency.subnetworks.outputs.subnets["us-central1/dataflow-${dependency.random_string.outputs.result}"].secondary_ip_range[0].ip_cidr_range
          dependency.subnetworks.outputs.subnets["us-central1/cloud-sql-${dependency.random_string.outputs.result}"].ip_cidr_range,
          dependency.subnetworks.outputs.subnets["us-central1/cloud-sql-${dependency.random_string.outputs.result}"].secondary_ip_range[0].ip_cidr_range
        ]
        target_tags              = [local.public]
        allow = [
          {
            protocol = "all"
            ports    = null
          }
        ]
        log_config = {
          metadata = "INCLUDE_ALL_METADATA"
        }
      },
      private-allow-all-network-inbound = {
        description = "tf managed - private - allow ingress from within this network"
        direction   = "INGRESS"
        action      = "allow"
        ranges = [
          dependency.subnetworks.outputs.subnets["us-central1/cluster-${dependency.random_string.outputs.result}"].ip_cidr_range,
          dependency.subnetworks.outputs.subnets["us-central1/cluster-${dependency.random_string.outputs.result}"].secondary_ip_range[0].ip_cidr_range,
          dependency.subnetworks.outputs.subnets["us-central1/cluster-${dependency.random_string.outputs.result}"].secondary_ip_range[1].ip_cidr_range,
          dependency.subnetworks.outputs.subnets["us-central1/dataflow-${dependency.random_string.outputs.result}"].ip_cidr_range,
          dependency.subnetworks.outputs.subnets["us-central1/dataflow-${dependency.random_string.outputs.result}"].secondary_ip_range[0].ip_cidr_range
        ]
        use_service_accounts = false
        targets              = [local.private]
        sources              = null
        rules = [
          {
            protocol = "all"
            ports    = null
          }
        ]
        extra_attributes = {
          priority = 1000
        }
      }
      private-allow-restricted-network-inbound = {
        description          = "tf managed - private-persistence - allow ingress from `private` and `private-persistence` instances in this network"
        direction            = "INGRESS"
        action               = "allow"
        ranges               = null
        use_service_accounts = false
        targets              = [local.private_persistence]
        sources              = [local.private, local.private_persistence]
        rules = [
          {
            protocol = "all"
            ports    = null
          }
        ]
        extra_attributes = {
          priority = 1000
        }
      }
    },

  ]

    length(local.allowed_public_restricted_subnetworks) > 0 ? {
      public-restricted-allow-network-inbound = local.public_restricted_allow_network_inbound
    } : {}
  )
}