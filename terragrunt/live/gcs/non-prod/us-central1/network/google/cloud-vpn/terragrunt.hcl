terraform {
  source = "github.com/terraform-google-modules/terraform-google-vpn.git//modules/vpn_ha?ref=v1.5.0"
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

dependency "cloud_routers" {
  config_path = "${get_parent_terragrunt_dir()}/non-prod/us-central1/network/google/cloud-routers"
}

dependency "compute_addresses" {
  config_path = "${get_parent_terragrunt_dir()}/non-prod/global/network/google/compute-addresses"
}

dependency "random_string" {
  config_path = "${get_parent_terragrunt_dir()}/non-prod/global/terraform/random/random-string"
}

dependency "compute_instances" {
  config_path = "${get_parent_terragrunt_dir()}/non-prod/us-central1/compute/google/compute-instances"
}

inputs = {
  project_id         = dependency.vpc.outputs.vpc_map["vpc-${dependency.random_string.outputs.result}"].project_id
  network            = dependency.vpc.outputs.vpc_map["vpc-${dependency.random_string.outputs.result}"].network_self_link
  region             = "us-central1"
  name               = "${dependency.vpc.outputs.vpc_map["vpc-${dependency.random_string.outputs.result}"].network["name"]}-ha-vpn"
  create_vpn_gateway = true
  router_name        = dependency.cloud_routers.outputs.cloud_routers_map["openvpn-${dependency.random_string.outputs.result}"].router["name"]
  peer_external_gateway = {
    redundancy_type = "SINGLE_IP_INTERNALLY_REDUNDANT"
    interfaces = [
      {
        id         = 0
        ip_address = dependency.compute_instances.outputs.compute_instances_map["openvpn-${dependency.random_string.outputs.result}"].network_interface[0].network_ip
      }
    ]
  }
  tunnels = {
    remote-0 = {
      bgp_peer = {
        address = "10.0.15.250"
        asn     = 64513
      }
      bgp_peer_options                = null
      bgp_session_range               = dependency.subnetworks.outputs.subnets["us-central1/cluster-${dependency.random_string.outputs.result}"].ip_cidr_range
      ike_version                     = 2
      vpn_gateway_interface           = 0
      peer_external_gateway_interface = 0
      shared_secret                   = ""
    }
  }
}
