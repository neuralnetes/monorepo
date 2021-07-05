terraform {
  source = "github.com/neuralnetes/monorepo.git//terraform/modules/google/service-project-subnetworks?ref=main"
}

include {
  path = find_in_parent_folders()
}

locals {
  gcp_workspace_domain_name = get_env("GCP_WORKSPACE_DOMAIN_NAME")
}

dependency "kubeflow_project" {
  config_path = "${get_parent_terragrunt_dir()}/non-prod/global/kubeflow/google/project"
}

dependency "network_project" {
  config_path = "${get_parent_terragrunt_dir()}/non-prod/global/network/google/project"
}

dependency "subnetworks" {
  config_path = "${get_parent_terragrunt_dir()}/non-prod/us-central1/network/google/subnetworks"
}

dependency "random_string" {
  config_path = "${get_parent_terragrunt_dir()}/shared/global/shared/random/random-string"
}

locals {
  region = "us-central1"
}

inputs = {
  service_project_subnetworks = [
    for subnet_name, subnet in dependency.subnetworks.outputs.subnets :
    {
      host_project_id      = dependency.network_project.outputs.project_id
      service_project_id   = dependency.kubeflow_project.outputs.project_id
      subnetwork_self_link = subnet["self_link"]
      region               = local.region
    }
  ]
}
