terraform {
  source = "github.com/terraform-google-modules/terraform-google-project-factory.git//?ref=v11.0.0"
}

include {
  path = find_in_parent_folders()
}

locals {
  gcp_workspace_domain_name = get_env("GCP_WORKSPACE_DOMAIN_NAME")
}

dependency "random_string" {
  config_path = "${get_parent_terragrunt_dir()}/shared/global/shared/random/random-string"
}

inputs = {
  name                 = "secret-${dependency.random_string.outputs.result}"
  random_project_id    = false
  skip_gcloud_download = true
  activate_apis = [
    "secretmanager.googleapis.com"
  ]
  domain = local.gcp_workspace_domain_name
}
