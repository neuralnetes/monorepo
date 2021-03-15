terraform {
  source = "git::git@github.com:neuralnetes/infra-modules.git//kustomization/bootstrap?ref=master"
}

include {
  path = find_in_parent_folders()
}

dependency "random_string" {
  config_path = "${get_parent_terragrunt_dir()}/non-prod/global/shared/random/random-string"
}

dependency "container_clusters" {
  config_path = "${get_terragrunt_dir()}/../../gcp/container-clusters"
}

generate "kustomization_provider" {
  path      = "kustomization_provider.tf"
  if_exists = "overwrite_terragrunt"
  contents  = <<EOF
terraform {
  required_providers {
    kustomization = {
      source = "kbst/kustomization"
      version = "${get_env("TF_PROVIDER_KUSTOMIZATION_VERSION")}"
    }
  }
}
provider "kustomization" {
  kubeconfig_raw = "${replace(dependency.container_clusters.outputs.container_cluster_auths["cluster-${dependency.random_string.outputs.result}"].kubeconfig_raw, "\n", "\\n")}"
}
EOF
}

inputs = {
  path = "${get_terragrunt_dir()}"
}
