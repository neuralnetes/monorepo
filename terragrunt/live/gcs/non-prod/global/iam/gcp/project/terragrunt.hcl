terraform {
  source = "git::git@github.com:terraform-google-modules/terraform-google-project-factory.git//modules/svpc_service_project?ref=v10.2.1"
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
  config_path = "${get_parent_terragrunt_dir()}/non-prod/global/shared/random/random-string"
}

inputs = {
  name                 = "data-${dependency.random_string.outputs.result}"
  random_project_id    = false
  skip_gcloud_download = true
  activate_apis = [
    "bigquery.googleapis.com",
    "pubsub.googleapis.com",
    "sqladmin.googleapis.com",
    "storage-api.googleapis.com"
  ]
  domain             = local.gcp_workspace_domain_name
  shared_vpc         = dependency.vpc.outputs.project_id
  shared_vpc_subnets = [for subnet in values(dependency.subnetworks.outputs.subnets) : subnet["self_link"]]
}
