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
  gcp_workspace_domain_name = get_env("GCP_WORKSPACE_DOMAIN_NAME")
}

inputs = {
  cloud_dns = flatten([
    for domain in [
      "${dependency.network_project.outputs.project_id}.${local.gcp_workspace_domain_name}",
      "${dependency.compute_project.outputs.project_id}.${dependency.network_project.outputs.project_id}.${local.gcp_workspace_domain_name}",
      "${dependency.kubeflow_project.outputs.project_id}.${dependency.network_project.outputs.project_id}.${local.gcp_workspace_domain_name}",
    ] :
    [
      for type in ["private", "public"] :
      {
        project_id = dependency.network_project.outputs.project_id
        type       = type
        name       = "${type}-${replace(domain, ".", "-")}"
        domain     = "${domain}."
        private_visibility_config_networks = [
          dependency.vpc.outputs.vpc_map["vpc-${dependency.random_string.outputs.result}"].network_self_link
        ]
        recordsets = [
          {
            name = "www"
            type = "CNAME"
            ttl  = 300
            records = [
              "${domain}."
            ]
          }
        ]
      }
    ]
  ])
}
