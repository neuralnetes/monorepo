terraform {
  source = "github.com/neuralnetes/monorepo.git//terraform/modules/google/cloud-dns?ref=main"
}

include {
  path = find_in_parent_folders()
}

dependency "network_project" {
  config_path = "${get_parent_terragrunt_dir()}/non-prod/global/network/google/project"
}

dependency "compute_project" {
  config_path = "${get_parent_terragrunt_dir()}/non-prod/global/compute/google/project"
}

dependency "kubeflow_project" {
  config_path = "${get_parent_terragrunt_dir()}/non-prod/global/kubeflow/google/project"
}

dependency "vpc" {
  config_path = "${get_parent_terragrunt_dir()}/non-prod/global/network/google/vpc"
}

dependency "random_string" {
  config_path = "${get_parent_terragrunt_dir()}/non-prod/global/terraform/random/random-string"
}

locals {
  gsuite_domain_name = get_env("GCP_WORKSPACE_DOMAIN_NAME")
}

inputs = {
  cloud_dns = [
    {
      project_id = dependency.network_project.outputs.project_id
      type       = "private"
      name       = replace("private-${dependency.network_project.outputs.project_id}-${local.gsuite_domain_name}", ".", "-")
      domain     = "${dependency.network_project.outputs.project_id}.${local.gsuite_domain_name}."
      private_visibility_config_networks = [
        dependency.vpc.outputs.network_self_link
      ]
    },
    {
      project_id                         = dependency.network_project.outputs.project_id
      type                               = "public"
      name                               = replace("public-${dependency.network_project.outputs.project_id}-${local.gsuite_domain_name}", ".", "-")
      domain                             = "${dependency.network_project.outputs.project_id}.${local.gsuite_domain_name}."
      private_visibility_config_networks = []
    },
    {
      project_id = dependency.network_project.outputs.project_id
      type       = "private"
      name       = replace("private-${dependency.kubeflow_project.outputs.project_id}-${dependency.network_project.outputs.project_id}-${local.gsuite_domain_name}", ".", "-")
      domain     = "${dependency.kubeflow_project.outputs.project_id}.${dependency.network_project.outputs.project_id}.${local.gsuite_domain_name}."
      private_visibility_config_networks = [
        dependency.vpc.outputs.network_self_link
      ]
    },
    {
      project_id                         = dependency.network_project.outputs.project_id
      type                               = "public"
      name                               = replace("public-${dependency.kubeflow_project.outputs.project_id}-${dependency.network_project.outputs.project_id}-${local.gsuite_domain_name}", ".", "-")
      domain                             = "${dependency.kubeflow_project.outputs.project_id}.${dependency.network_project.outputs.project_id}.${local.gsuite_domain_name}."
      private_visibility_config_networks = []
    },
    {
      project_id = dependency.network_project.outputs.project_id
      type       = "private"
      name       = replace("private-${dependency.compute_project.outputs.project_id}-${dependency.network_project.outputs.project_id}-${local.gsuite_domain_name}", ".", "-")
      domain     = "${dependency.compute_project.outputs.project_id}.${dependency.network_project.outputs.project_id}.${local.gsuite_domain_name}."
      private_visibility_config_networks = [
        dependency.vpc.outputs.network_self_link
      ]
    },
    {
      project_id                         = dependency.network_project.outputs.project_id
      type                               = "public"
      name                               = replace("public-${dependency.compute_project.outputs.project_id}-${dependency.network_project.outputs.project_id}-${local.gsuite_domain_name}", ".", "-")
      domain                             = "${dependency.compute_project.outputs.project_id}.${dependency.network_project.outputs.project_id}.${local.gsuite_domain_name}."
      private_visibility_config_networks = []
    },
  ]
}