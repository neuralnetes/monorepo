terraform {
  source = "github.com/neuralnetes/monorepo.git//terraform/modules/null-resource/cluster-kustomizations?ref=main"
}

include {
  path = find_in_parent_folders()
}

dependency "compute_project" {
  config_path = "${get_parent_terragrunt_dir()}/non-prod/global/compute/google/project"
}

dependency "iam_project" {
  config_path = "${get_parent_terragrunt_dir()}/non-prod/global/iam/google/project"
}

dependency "network_project" {
  config_path = "${get_parent_terragrunt_dir()}/non-prod/global/network/google/project"
}

dependency "container_clusters" {
  config_path = "${get_parent_terragrunt_dir()}/non-prod/us-central1/compute/google/container-clusters"
}

dependency "container_cluster_auths" {
  config_path = "${get_parent_terragrunt_dir()}/non-prod/us-central1/compute/google/container-cluster-auths"
}

dependency "random_string" {
  config_path = "${get_parent_terragrunt_dir()}/non-prod/global/terraform/random/random-string"
}

locals {
  github_workspace = get_env("GITHUB_WORKSPACE")
}

inputs = {
  cluster_kustomizations = [
    {
      github_workspace = local.github_workspace
      cluster_name     = dependency.container_clusters.outputs.container_clusters_map["cluster-${dependency.random_string.outputs.result}"].cluster_name
      compute_project  = dependency.compute_project.outputs.project_id
      iam_project      = dependency.iam_project.outputs.project_id
      network_project  = dependency.network_project.outputs.project_id
      triggers = {
        filebase64sha256 = filebase64sha256("${local.github_workspace}/bash/kustomize/kustomize_cluster.sh")
      }
    }
  ]
}
