terraform {
  source = "github.com/terraform-google-modules/terraform-google-project-factory.git//?ref=v11.0.0"
}

include {
  path = find_in_parent_folders()
}

locals {
  gcp_workspace_domain_name = get_env("GCP_WORKSPACE_DOMAIN_NAME")
}

dependency "network_project" {
  config_path = "${get_parent_terragrunt_dir()}/non-prod/global/network/google/project"
}

dependency "random_string" {
  config_path = "${get_parent_terragrunt_dir()}/shared/global/shared/random/random-string"
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
    "iam.googleapis.com",
    "ml.googleapis.com",
    "servicemanagement.googleapis.com",
  ]
  domain               = local.gcp_workspace_domain_name
  svpc_host_project_id = dependency.network_project.outputs.project_id
}

skip = false
