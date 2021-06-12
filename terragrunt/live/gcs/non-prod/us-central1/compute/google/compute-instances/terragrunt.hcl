terraform {
  source = "github.com/neuralnetes/monorepo.git//terraform/modules/google/compute-instances?ref=main"
}

include {
  path = find_in_parent_folders()
}

dependency "compute_project" {
  config_path = "${get_parent_terragrunt_dir()}/non-prod/global/compute/google/project"
}

dependency "service_accounts" {
  config_path = "${get_parent_terragrunt_dir()}/non-prod/global/iam/google/service-accounts"
}

dependency "project_iam_bindings" {
  config_path = "${get_parent_terragrunt_dir()}/non-prod/global/iam/google/project-iam-bindings"
}

dependency "service_account_iam_bindings" {
  config_path = "${get_parent_terragrunt_dir()}/non-prod/global/iam/google/service-account-iam-bindings"
}

dependency "service_account_access_tokens" {
  config_path = "${get_parent_terragrunt_dir()}/non-prod/global/iam/google/service-account-access-tokens"
}

dependency "vpc" {
  config_path = "${get_parent_terragrunt_dir()}/non-prod/global/network/google/vpc"
}

dependency "subnetworks" {
  config_path = "${get_parent_terragrunt_dir()}/non-prod/us-central1/network/google/subnetworks"
}

dependency "firewall_rules" {
  config_path = "${get_parent_terragrunt_dir()}/non-prod/us-central1/network/google/firewall-rules"
}

dependency "random_string" {
  config_path = "${get_parent_terragrunt_dir()}/non-prod/global/terraform/random/random-string"
}

dependency "tags" {
  config_path = "${get_parent_terragrunt_dir()}/non-prod/global/terraform/google/tags"
}

generate "google_provider" {
  path      = "google_provider.tf"
  if_exists = "overwrite_terragrunt"
  contents  = <<-EOF
    provider "google" {
      alias = "impersonated"
      access_token = "${dependency.service_account_access_tokens.outputs.service_account_access_tokens_map["compute-instance"].access_token}"
    }
EOF
}

generate "google_beta_provider" {
  path      = "google_beta_provider.tf"
  if_exists = "overwrite_terragrunt"
  contents  = <<-EOF
    provider "google-beta" {
      alias = "impersonated"
      access_token = "${dependency.service_account_access_tokens.outputs.service_account_access_tokens_map["compute-instance"].access_token}"
    }
EOF
}

inputs = {
  compute_instances = [
    {
      name                  = "public-${dependency.random_string.outputs.result}"
      machine_type          = "e2-micro"
      image_project         = "ubuntu-os-cloud"
      image_family          = "ubuntu-2004-lts"
      project               = dependency.compute_project.outputs.project_id
      zone                  = "us-central1-a"
      network               = dependency.vpc.outputs.vpc_map["vpc-${dependency.random_string.outputs.result}"].network_self_link
      subnetwork            = dependency.subnetworks.outputs.subnets["us-central1/cluster-${dependency.random_string.outputs.result}"].self_link
      service_account_email = dependency.service_accounts.outputs.service_accounts_map["compute-instance"].email
      tags = [
        dependency.tags.outputs.tags_map["public"]
      ]
      metadata_startup_script = templatefile("${get_terragrunt_dir()}/templates/test.tpl", {
        name = "test"
      })
    }
  ]
}

skip = true