terraform {
  source = "git::git@github.com:terraform-google-modules/terraform-google-project-factory.git//modules/svpc_service_project?ref=v10.2.1"
}

include {
  path = find_in_parent_folders()
}

locals {
  gcp_workspace_domain_name = get_env("GCP_WORKSPACE_DOMAIN_NAME")
}

dependency "random_string" {
  config_path = "${get_parent_terragrunt_dir()}/non-prod/global/shared/random/random-string"
}

inputs = {
  name                 = "iam-${dependency.random_string.outputs.result}"
  random_project_id    = false
  skip_gcloud_download = true
  activate_apis = [
    "cloudresourcemanager.googleapis.com",
    "iam.googleapis.com"
  ]
  domain             = local.gcp_workspace_domain_name
  shared_vpc         = null
  shared_vpc_subnets = []
}
