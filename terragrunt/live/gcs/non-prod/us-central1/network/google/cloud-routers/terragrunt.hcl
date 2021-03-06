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

inputs = {
  cloud_routers = [
    {
      project = dependency.vpc.outputs.vpc_map["vpc-01"].project_id
      network = dependency.vpc.outputs.vpc_map["vpc-01"].network_name
      name    = "router-01"
      bgp = {
        asn               = "64519"
        advertised_groups = ["ALL_SUBNETS"]
      }
      region = "us-central1"
    }
  ]
}