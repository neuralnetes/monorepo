terraform {
  source = "https://github.com/terraform-google-modules/terraform-google-project-factory.git//ref=v10.2.1"
}

include {
  path = find_in_parent_folders()
}

locals {
  gcp_workspace_domain_name = get_env("GCP_WORKSPACE_DOMAIN_NAME")
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

inputs = {
  name                 = "terraform-${get_env("GCP_ORGANIZATION")}"
  activate_apis = [
    "cloudresourcemanager.googleapis.com",
    "compute.googleapis.com",
    "container.googleapis.com",
    "dataflow.googleapis.com",
    "ml.googleapis.com",
    "servicemanagement.googleapis.com",
  ]
}
