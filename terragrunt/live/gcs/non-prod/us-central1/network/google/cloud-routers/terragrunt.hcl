terraform {
  source = "github.com/neuralnetes/monorepo.git//terraform/modules/google/cloud-routers?ref=main"
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

dependency "random_string" {
  config_path = "${get_parent_terragrunt_dir()}/non-prod/global/terraform/random/random-string"
}

inputs = {
  cloud_routers = [
    {
      project = dependency.vpc.outputs.project_id
      network = dependency.vpc.outputs.network_name
      name    = "public-${dependency.random_string.outputs.result}"
      bgp     = null
      region  = "us-central1"
    },
    {
      project = dependency.vpc.outputs.project_id
      network = dependency.vpc.outputs.network_name
      name    = "private-${dependency.random_string.outputs.result}"
      bgp     = null
      region  = "us-central1"
    },
    {
      project = dependency.vpc.outputs.project_id
      network = dependency.vpc.outputs.network_name
      name    = "openvpn-${dependency.random_string.outputs.result}"
      bgp = {
        asn               = "64519"
        advertised_groups = ["ALL_SUBNETS"]
      }
      region = "us-central1"
    },
  ]
}