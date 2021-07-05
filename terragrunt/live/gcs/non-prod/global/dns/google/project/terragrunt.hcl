terraform {
  source = "github.com/terraform-google-modules/terraform-google-project-factory.git//?ref=v11.0.0"
}

include {
  path = find_in_parent_folders()
}

dependency "terraform_project" {
  config_path = "${get_parent_terragrunt_dir()}/non-prod/global/terraform/google/project"
}

locals {
  gcp_workspace_domain_name = get_env("GCP_WORKSPACE_DOMAIN_NAME")
}

inputs = {
  name                 = "dns-non-prod-${replace(local.gcp_workspace_domain_name, ".", "-")}"
  random_project_id    = false
  skip_gcloud_download = true
  activate_apis = [
    "dns.googleapis.com"
  ]
  domain                         = local.gcp_workspace_domain_name
  enable_shared_vpc_host_project = false
}
