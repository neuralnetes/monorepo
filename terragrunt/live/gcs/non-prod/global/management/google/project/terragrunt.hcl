terraform {
  source = "github.com/terraform-google-modules/terraform-google-project-factory.git//modules/svpc_service_project?ref=v11.0.0"
}

include {
  path = find_in_parent_folders()
}

locals {
  gcp_workspace_domain_name = get_env("GCP_WORKSPACE_DOMAIN_NAME")
}

dependency "terraform_project" {
  config_path = "${get_parent_terragrunt_dir()}/non-prod/global/terraform/google/project"
}

dependency "vpc" {
  config_path = "${get_parent_terragrunt_dir()}/non-prod/global/network/google/vpc"
}

dependency "subnetworks" {
  config_path = "${get_parent_terragrunt_dir()}/non-prod/us-central1/network/google/subnetworks"
}

dependency "random_string" {
  config_path = "${get_parent_terragrunt_dir()}/non-prod/global/terraform/random/random-string"
}

inputs = {
  name                 = "management-${dependency.random_string.outputs.result}"
  random_project_id    = false
  skip_gcloud_download = true
  activate_apis = [
    "cloudresourcemanager.googleapis.com",
    "compute.googleapis.com",
    "container.googleapis.com",
    "dataflow.googleapis.com",
    "ml.googleapis.com",
    "servicemanagement.googleapis.com",
    "iam.googleapis.com"
  ]
  domain             = local.gcp_workspace_domain_name
  shared_vpc         = dependency.vpc.outputs.vpc_map["vpc-${dependency.random_string.outputs.result}"].project_id
  shared_vpc_subnets = [for subnet in values(dependency.subnetworks.outputs.subnets) : subnet["self_link"]]
}
