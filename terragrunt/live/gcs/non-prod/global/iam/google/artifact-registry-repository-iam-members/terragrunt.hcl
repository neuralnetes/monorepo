terraform {
  source = "github.com/neuralnetes/monorepo.git//terraform/modules/google/artifact-registry-repository-iam-members?ref=main"
}

include {
  path = find_in_parent_folders()
}

dependency "artifact_project" {
  config_path = "${get_parent_terragrunt_dir()}/non-prod/global/artifact/google/project"
}

dependency "artifact_registries" {
  config_path = "${get_parent_terragrunt_dir()}/non-prod/global/artifact/google/artifact-registries"
}

dependency "iam_project" {
  config_path = "${get_parent_terragrunt_dir()}/non-prod/global/iam/google/project"
}

dependency "service_accounts" {
  config_path = "${get_parent_terragrunt_dir()}/non-prod/global/iam/google/service-accounts"
}

dependency "project_iam_bindings" {
  config_path = "${get_parent_terragrunt_dir()}/non-prod/global/iam/google/project-iam-bindings"
}

dependency "container_clusters" {
  config_path = "${get_parent_terragrunt_dir()}/non-prod/us-central1/kubeflow/google/container-clusters"
}

dependency "auth" {
  config_path = "${get_parent_terragrunt_dir()}/non-prod/global/terraform/google/auth"
}

dependency "random_string" {
  config_path = "${get_parent_terragrunt_dir()}/non-prod/global/terraform/random/random-string"
}

locals {
  gcp_workspace_domain_name = get_env("GCP_WORKSPACE_DOMAIN_NAME")
}

inputs = {
  artifact_registry_repository_iam_members = [
    //    {
    //      name       = "cluster-${dependency.random_string.outputs.result}-01"
    //      location   = "us-central1"
    //      repository = "cluster-${dependency.random_string.outputs.result}"
    //      role       = "roles/artifactregistry.reader"
    //      member     = "serviceAccount:tf-gke-cluster-cklf-35c6@kubeflow-cklf.iam.gserviceaccount.com"
    //      project    = dependency.artifact_project.outputs.project_id
    //    }
  ]
}
