terraform {
  source = "github.com/neuralnetes/monorepo.git//terraform/modules/google/compute-addresses?ref=main"
}

include {
  path = find_in_parent_folders()
}

dependency "project_iam_bindings" {
  config_path = "${get_parent_terragrunt_dir()}/non-prod/global/iam/google/project-iam-bindings"
}

dependency "network_project" {
  config_path = "${get_parent_terragrunt_dir()}/non-prod/global/network/google/project"
}

dependency "vpc" {
  config_path = "${get_parent_terragrunt_dir()}/non-prod/global/network/google/vpc"
}

dependency "random_string" {
  config_path = "${get_parent_terragrunt_dir()}/shared/global/shared/random/random-string"
}

inputs = {
  global_addresses = [
    {
      project       = dependency.network_project.outputs.project_id
      name          = "global-google-managed-services"
      prefix_length = 16
      purpose       = "VPC_PEERING"
      address_type  = "INTERNAL"
      network       = dependency.vpc.outputs.vpc_map["vpc-01"].network["id"]
    }
  ]
}