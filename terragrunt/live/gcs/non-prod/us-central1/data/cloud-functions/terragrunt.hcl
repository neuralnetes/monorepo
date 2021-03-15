terraform {
  source = "git::git@github.com:neuralnetes/monorepo.git//terraform/modules/gcp/cloud-functions?ref=main"
}

include {
  path = find_in_parent_folders()
}

dependency "project" {
  config_path = "${get_parent_terragrunt_dir()}/non-prod/global/data/gcp/project"
}

dependency "project_iam_bindings" {
  config_path = "${get_parent_terragrunt_dir()}/non-prod/global/data/gcp/project-iam-bindings"
}

dependency "service_account_iam_bindings" {
  config_path = "${get_parent_terragrunt_dir()}/non-prod/global/data/gcp/service-account-iam-bindings"
}

dependency "service_accounts" {
  config_path = "${get_parent_terragrunt_dir()}/non-prod/global/data/gcp/service-accounts"
}

dependency "cloud_storage" {
  config_path = "${get_parent_terragrunt_dir()}/non-prod/global/data/gcp/cloud-storage"
}

dependency "pubsub" {
  config_path = "${get_parent_terragrunt_dir()}/non-prod/global/data/gcp/pubsub"
}

dependency "bigquery_datasets" {
  config_path = "${get_parent_terragrunt_dir()}/non-prod/global/data/gcp/bigquery-datasets"
}

dependency "repositories" {
  config_path = "${get_parent_terragrunt_dir()}/non-prod/global/shared/github/repositories"
}

dependency "branches" {
  config_path = "${get_parent_terragrunt_dir()}/non-prod/global/shared/github/branches"
}

dependency "random_string" {
  config_path = "${get_parent_terragrunt_dir()}/non-prod/global/shared/random/random-string"
}

locals {
  region = "us-central1"
}

inputs = {
  cloud_functions = []
}