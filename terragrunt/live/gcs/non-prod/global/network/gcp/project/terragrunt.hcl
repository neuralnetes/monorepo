terraform {
  source = "git::git@github.com:terraform-google-modules/terraform-google-project-factory.git?ref=v10.2.1"
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
  name                 = "network-${dependency.random_string.outputs.result}"
  random_project_id    = false
  skip_gcloud_download = true
  activate_apis = [
    "dns.googleapis.com"
  ]
  domain                         = local.gcp_workspace_domain_name
  enable_shared_vpc_host_project = true
}
