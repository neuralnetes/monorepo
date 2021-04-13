terraform {
  source = "github.com/terraform-google-modules/terraform-google-network.git//modules/vpc?ref=v3.2.1"
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
  project_id                             = dependency.network_project.outputs.project_id
  network_name                           = "vpc-${dependency.random_string.outputs.result}"
  shared_vpc_host                        = true
  routing_mode                           = "REGIONAL"
  delete_default_internet_gateway_routes = false
}
