locals {
  account_vars     = read_terragrunt_config(find_in_parent_folders("account.hcl"))
  region_vars      = read_terragrunt_config(find_in_parent_folders("region.hcl"))
  environment_vars = read_terragrunt_config(find_in_parent_folders("env.hcl"))
}

remote_state {
  backend = "gcs"
  generate = {
    path      = "gcs_backend.tf"
    if_exists = "overwrite_terragrunt"
  }
  config = {
    project = get_env("GCP_PROJECT_ID")
    bucket = get_env("GCS_TERRAFORM_REMOTE_STATE_BUCKET")
    location = get_env("GCS_TERRAFORM_REMOTE_STATE_LOCATION")
    prefix = "${path_relative_to_include()}/terraform.tfstate"
  }
}

generate "google_provider" {
  path      = "google_provider.tf"
  if_exists = "overwrite_terragrunt"
  contents  = <<EOF
provider "google" {}
EOF
}

generate "google_beta_provider" {
  path      = "google_beta_provider.tf"
  if_exists = "overwrite_terragrunt"
  contents  = <<EOF
provider "google-beta" {}
EOF
}

generate "github_provider" {
  path      = "github_provider.tf"
  if_exists = "overwrite_terragrunt"
  contents  = <<EOF
provider "github" {
  organization = "${get_env("GH_ORGANIZATION")}"
  token = "${get_env("GH_TOKEN")}"
}
EOF
}

inputs = merge(
  local.account_vars.locals,
  local.region_vars.locals,
  local.environment_vars.locals,
)
