terraform {
  source = "github.com/neuralnetes/monorepo.git//terraform/modules/google/artifact-registries?ref=main"
}

include {
  path = find_in_parent_folders()
}

dependency "artifact_project" {
  config_path = "${get_parent_terragrunt_dir()}/non-prod/global/artifact/google/project"
}

dependency "kubeflow_project" {
  config_path = "${get_parent_terragrunt_dir()}/non-prod/global/kubeflow/google/project"
}

dependency "management_project" {
  config_path = "${get_parent_terragrunt_dir()}/non-prod/global/management/google/project"
}

dependency "project_iam_bindings" {
  config_path = "${get_parent_terragrunt_dir()}/non-prod/global/iam/google/project-iam-bindings"
}

dependency "random_string" {
  config_path = "${get_parent_terragrunt_dir()}/non-prod/global/terraform/random/random-string"
}

inputs = {
  artifact_registries = [
    for project_id in [
      dependency.kubeflow_project.outputs.project_id,
      dependency.management_project.outputs.project_id,
    ] :
    {
      location      = "us-central1"
      repository_id = project_id
      description   = project_id
      format        = "DOCKER"
      project       = dependency.artifact_project.outputs.project_id
    }
  ]
}
