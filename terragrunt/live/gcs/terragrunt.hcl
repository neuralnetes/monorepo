locals {
  account_vars     = read_terragrunt_config(find_in_parent_folders("account.hcl"))
  region_vars      = read_terragrunt_config(find_in_parent_folders("region.hcl"))
  environment_vars = read_terragrunt_config(find_in_parent_folders("env.hcl"))
}

//remote_state {
//  backend = "gcs"
//  generate = {
//    path      = "gcs_backend.tf"
//    if_exists = "overwrite_terragrunt"
//  }
//  config = {
//    project  = get_env("GCP_PROJECT_ID")
//    location = get_env("GCS_TERRAFORM_REMOTE_STATE_LOCATION")
//    bucket   = get_env("GCS_TERRAFORM_REMOTE_STATE_BUCKET")
//    prefix   = "${path_relative_to_include()}/terraform.tfstate"
//  }
//}

generate "remote_state" {
  path      = "terraform_cloud_remote_state.tf"
  if_exists = "overwrite_terragrunt"
  contents  = <<EOF
terraform {
  backend "remote" {
    hostname = "app.terraform.io"
    organization = "${get_env("TERRAFORM_CLOUD_ORGANIZATION")}"
    token = "${get_env("TERRAFORM_CLOUD_TOKEN")}"

    workspaces {
      name = "${replace(path_relative_to_include(), "/", "-")}"
    }
  }
}
EOF
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
provider "github" {}
EOF
}

inputs = merge(
  local.account_vars.locals,
  local.region_vars.locals,
  local.environment_vars.locals,
)
