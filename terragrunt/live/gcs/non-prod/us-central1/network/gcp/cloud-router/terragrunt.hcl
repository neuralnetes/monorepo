terraform {
  source = "github.com/terraform-google-modules/terraform-google-cloud-router.git?ref=v0.4.0"
}

include {
  path = find_in_parent_folders()
}

dependency "vpc" {
  config_path = "${get_parent_terragrunt_dir()}/non-prod/global/network/gcp/vpc"
}

dependency "random_string" {
  config_path = "${get_parent_terragrunt_dir()}/non-prod/global/terraform/random/random-string"
}

inputs = {
  project = dependency.vpc.outputs.project_id
  network = dependency.vpc.outputs.network_name
  name    = "router-${dependency.random_string.outputs.result}"
}