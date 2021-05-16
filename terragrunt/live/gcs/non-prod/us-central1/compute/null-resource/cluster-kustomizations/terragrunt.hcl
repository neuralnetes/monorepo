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
  github_client_id     = get_env("GITHUB_CLIENT_ID")
  github_client_secret = get_env("GITHUB_CLIENT_SECRET")
  github_owner         = get_env("GITHUB_OWNER")
  github_workspace     = get_env("GITHUB_WORKSPACE")
  filebase64sha256     = filebase64sha256("${local.github_workspace}/bash/kustomize/kustomize_cluster.sh")
  paths = [
    "${local.github_workspace}/kustomize/manifests/external-secrets/overlays/${dependency.compute_project.outputs.project_id}",
    "${local.github_workspace}/kustomize/manifests/external-dns/overlays/${dependency.compute_project.outputs.project_id}",
    "${local.github_workspace}/kustomize/manifests/secrets/kubeflow/overlays/${dependency.compute_project.outputs.project_id}",
    "${local.github_workspace}/kustomize/manifests/secrets/istio-system/overlays/${dependency.compute_project.outputs.project_id}",
    "${local.github_workspace}/kustomize/manifests/kubeflow/1.3/overlays/${dependency.compute_project.outputs.project_id}/common/cert-manager/cert-manager/overlays/letsencrypt",
    "${local.github_workspace}/kustomize/manifests/kubeflow/1.3/overlays/${dependency.compute_project.outputs.project_id}/common/istio-1-9-0/istio-install/base",
    "${local.github_workspace}/kustomize/manifests/kubeflow/1.3/overlays/${dependency.compute_project.outputs.project_id}/common/oidc-authservice/base",
    "${local.github_workspace}/kustomize/manifests/kubeflow/1.3/overlays/${dependency.compute_project.outputs.project_id}/common/dex/overlays/istio",
    "${local.github_workspace}/kustomize/manifests/kubeflow/1.3/overlays/${dependency.compute_project.outputs.project_id}/common/knative/knative-serving-install/base",
    "${local.github_workspace}/kustomize/manifests/kubeflow/1.3/overlays/${dependency.compute_project.outputs.project_id}/common/istio-1-9-0/kubeflow-istio-resources/base",
    "${local.github_workspace}/kustomize/manifests/deploy/overlays/${dependency.compute_project.outputs.project_id}",
    "${local.github_workspace}/kustomize/manifests/flux-kustomization/external-secrets/overlays/${dependency.compute_project.outputs.project_id}",
    "${local.github_workspace}/kustomize/manifests/flux-kustomization/external-dns/overlays/${dependency.compute_project.outputs.project_id}",
    "${local.github_workspace}/kustomize/manifests/flux-kustomization/secrets/kubeflow/overlays/${dependency.compute_project.outputs.project_id}",
    "${local.github_workspace}/kustomize/manifests/flux-kustomization/secrets/istio-system/overlays/${dependency.compute_project.outputs.project_id}",
    "${local.github_workspace}/kustomize/manifests/flux-kustomization/kubeflow/1.3/overlays/${dependency.compute_project.outputs.project_id}",
    "${local.github_workspace}/kustomize/manifests/flux-kustomization/cluster/overlays/${dependency.compute_project.outputs.project_id}",
    "${local.github_workspace}/kustomize/manifests/flux-kustomization/deploy/overlays/${dependency.compute_project.outputs.project_id}",
  ]
  triggers = merge({
    for path in local.paths :
    path => filebase64sha256(path)
    }, {
    filebase64sha256 = local.filebase64sha256
    timestamp        = timestamp()
  })
}

inputs = {
  cluster_kustomizations = [
    {
      github_client_id     = local.github_client_id
      github_client_secret = local.github_client_secret
      github_owner         = local.github_owner
      github_workspace     = local.github_workspace
      cluster_name         = dependency.container_clusters.outputs.container_clusters_map["cluster-${dependency.random_string.outputs.result}"].cluster_name
      compute_project      = dependency.compute_project.outputs.project_id
      iam_project          = dependency.iam_project.outputs.project_id
      network_project      = dependency.network_project.outputs.project_id
      kubeflow_project     = dependency.compute_project.outputs.project_id
      triggers             = local.triggers
    }
  ]
}
