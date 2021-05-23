terraform {
  source = "github.com/terraform-google-modules/terraform-google-vpn.git//modules/vpn_ha?ref=master"
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

dependency "cloud_router" {
  config_path = "${get_parent_terragrunt_dir()}/non-prod/us-central1/network/google/cloud-router"
}

dependency "compute_addresses" {
  config_path = "${get_parent_terragrunt_dir()}/non-prod/global/network/google/compute-addresses"
}

dependency "random_string" {
  config_path = "${get_parent_terragrunt_dir()}/non-prod/global/terraform/random/random-string"
}

inputs = {
  project_id            = dependency.vpc.outputs.project_id
  network               = dependency.vpc.outputs.network_self_link
  region                = "us-central1"
  name                  = "${dependency.vpc.outputs.network["name"]}-ha-vpn"
  create_vpn_gateway    = true
  router_name           = dependency.cloud_router.outputs.router["name"]
  peer_external_gateway = null
  tunnels = {
    remote-0 = {
      bgp_peer = {
        address = "100.96.1.18"
        asn     = 64513
      }
      bgp_peer_options                = null
      bgp_session_range               = "100.96.1.16/28"
      ike_version                     = 2
      vpn_gateway_interface           = 0
      peer_external_gateway_interface = 0
    }
  }
}
