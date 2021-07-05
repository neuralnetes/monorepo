terraform {
  source = "github.com/neuralnetes/monorepo.git//terraform/modules/google/artifact-registry-repositories?ref=main"
}

include {
  path = find_in_parent_folders()
}

dependency "artifact_project" {
  config_path = "${get_parent_terragrunt_dir()}/non-prod/global/artifact/google/project"
}

dependency "random_string" {
  config_path = "${get_parent_terragrunt_dir()}/shared/global/shared/random/random-string"
}

inputs = {
  artifact_registry_repositories = [
    for project_id in [
      "kubeflow-${dependency.random_string.outputs.result}",
      "management-${dependency.random_string.outputs.result}",
    ] :
    {
      location      = "us"
      repository_id = project_id
      description   = project_id
      format        = "DOCKER"
      project       = dependency.artifact_project.outputs.project_id
    }
  ]
}
