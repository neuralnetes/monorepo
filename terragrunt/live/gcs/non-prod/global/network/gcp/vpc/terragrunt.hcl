terraform {
  source = "git::git@github.com:terraform-google-modules/terraform-google-network.git//modules/vpc?ref=v3.2.0"
}

include {
  path = find_in_parent_folders()
}

dependency "project" {
  config_path = "${get_terragrunt_dir()}/../project"
}



dependency "random_string" {
  config_path = "${get_parent_terragrunt_dir()}/non-prod/global/shared/random/random-string"
}

inputs = {
  project_id      = dependency.project.outputs.project_id
  network_name    = "vpc-${dependency.random_string.outputs.result}"
  shared_vpc_host = true
  routing_mode    = "REGIONAL"
}