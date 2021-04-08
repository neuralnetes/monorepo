terraform {
  source = "github.com/neuralnetes/monorepo.git//terraform/modules/kustomization/deploy?ref=main"
}

include {
  path = find_in_parent_folders()
}

dependency "random_string" {
  config_path = "${get_parent_terragrunt_dir()}/non-prod/global/terraform/random/random-string"
}

dependency "container_clusters" {
  config_path = "${get_parent_terragrunt_dir()}/non-prod/us-central1/compute/gcp/container-clusters"
}

inputs = {
  path           = "${get_terragrunt_dir()}"
  kubeconfig_raw = dependency.container_clusters.outputs.container_cluster_auths_map["cluster-${dependency.random_string.outputs.result}"].kubeconfig_raw
}
