terraform {
  source = "github.com/neuralnetes/monorepo.git//terraform/modules/null-resource/cluster-kustomize?ref=main"
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

inputs = {
  github_workspace = get_env("GITHUB_WORKSPACE")
  github_token     = get_env("GITHUB_TOKEN")
  compute_project  = dependency.compute_project.outputs.project_id
  iam_project      = dependency.iam_project.outputs.project_id
  network_project  = dependency.network_project.outputs.project_id
}
