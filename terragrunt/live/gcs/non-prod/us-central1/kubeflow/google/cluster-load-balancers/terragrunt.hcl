terraform {
  source = "github.com/neuralnetes/monorepo.git//terraform/modules/google/cluster-load-balancers?ref=main"
}

include {
  path = find_in_parent_folders()
}

dependency "network_project" {
  config_path = "${get_parent_terragrunt_dir()}/non-prod/global/network/google/project"
}

dependency "kubeflow_project" {
  config_path = "${get_parent_terragrunt_dir()}/non-prod/global/kubeflow/google/project"
}

dependency "project_iam_bindings" {
  config_path = "${get_parent_terragrunt_dir()}/non-prod/global/iam/google/project-iam-bindings"
}

dependency "container_clusters" {
  config_path = "${get_parent_terragrunt_dir()}/non-prod/us-central1/kubeflow/google/container-clusters"
}

dependency "random_string" {
  config_path = "${get_parent_terragrunt_dir()}/non-prod/global/terraform/random/random-string"
}

locals {
  gcp_workspace_domain_name = get_env("GCP_WORKSPACE_DOMAIN_NAME")
}

inputs = {
  cluster_load_balancers = [
    //    {
    //      name              = "cluster-${dependency.random_string.outputs.result}"
    //      cluster_project   = dependency.kubeflow_project.outputs.project_id
    //      cluster_name      = dependency.container_clusters.outputs.container_clusters_map["cluster-${dependency.random_string.outputs.result}"].cluster_name
    //      cluster_location  = "us-central1-a"
    //      cert_dns_names    = ["*.${dependency.kubeflow_project.outputs.project_id}.${dependency.network_project.outputs.project_id}.${local.gcp_workspace_domain_name}"]
    //      cert_common_name  = "${dependency.kubeflow_project.outputs.project_id}.${dependency.network_project.outputs.project_id}.${local.gcp_workspace_domain_name}"
    //      cert_organization = local.gcp_workspace_domain_name
    //    }
  ]
}