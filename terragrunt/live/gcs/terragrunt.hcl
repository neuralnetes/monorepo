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
    bucket   = get_env("GCP_TERRAFORM_REMOTE_STATE_BUCKET")
    prefix   = "${path_relative_to_include()}/terraform.tfstate"
  }
}

generate "required_providers" {
  path      = "kustomization_provider.tf"
  if_exists = "overwrite_terragrunt"
  contents  = <<EOF
terraform {
  required_providers {
    # https://registry.terraform.io/providers/integrations/github/latest
    github = {
      source = "integrations/github"
      version = "${get_env("TF_PROVIDER_GITHUB_VERSION")}"
    }
    # https://registry.terraform.io/providers/hashicorp/google/latest
    google = {
      source = "hashicorp/google"
      version = "${get_env("TF_PROVIDER_GOOGLE_VERSION")}"
    }
    # https://registry.terraform.io/providers/hashicorp/google-beta/latest
    google-beta = {
      source = "hashicorp/google-beta"
      version = "${get_env("TF_PROVIDER_GOOGLE_BETA_VERSION")}"
    }
    # https://registry.terraform.io/providers/kbst/kustomization/latest
    kustomization = {
      source = "kbst/kustomization"
      version = "${get_env("TF_PROVIDER_KUSTOMIZATION_VERSION")}"
    }
    # https://registry.terraform.io/providers/hashicorp/random/latest
    random = {
      source = "hashicorp/random"
      version = "${get_env("TF_PROVIDER_RANDOM_VERSION")}"
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
