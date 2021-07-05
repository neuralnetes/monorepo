terraform {
  source = "github.com/neuralnetes/monorepo.git//terraform/modules/google/vpc?ref=main"
}

include {
  path = find_in_parent_folders()
}

dependency "network_project" {
  config_path = "${get_parent_terragrunt_dir()}/non-prod/global/network/google/project"
}

dependency "random_string" {
  config_path = "${get_parent_terragrunt_dir()}/non-prod/global/terraform/random/random-string"
}

inputs = {
  vpc = [
    {
      project_id                             = dependency.network_project.outputs.project_id
      network_name                           = "vpc-01"
      shared_vpc_host                        = true
      routing_mode                           = "REGIONAL"
      delete_default_internet_gateway_routes = false
      auto_create_subnetworks                = false
    }
  ]
}
