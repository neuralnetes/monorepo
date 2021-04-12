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
  config_path = "${get_parent_terragrunt_dir()}/non-prod/us-central1/compute/google/container-clusters"
}

dependency "container_cluster_auths" {
  config_path = "${get_parent_terragrunt_dir()}/non-prod/us-central1/compute/google/container-cluster-auths"
}

generate "kustomization_provider" {
  path      = "kustomization_provider.tf"
  if_exists = "overwrite_terragrunt"
  contents  = <<-EOF
    terraform {
      required_providers {
        kustomization = {
          source = "kbst/kustomization"
          version = "0.4.3"
        }
      }
    }
    provider "kustomization" {
      kubeconfig_raw = "${dependency.container_cluster_auths.outputs.kubeconfig_raws_map["cluster-${dependency.random_string.outputs.result}"]}"
    }
EOF
}

inputs = {
  path = "${get_env("GITHUB_WORKSPACE")}/kustomize/manifests/deploy/overlays/compute"
}
