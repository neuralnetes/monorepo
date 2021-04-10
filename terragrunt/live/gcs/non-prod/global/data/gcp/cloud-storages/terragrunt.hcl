terraform {
  source = "github.com/neuralnetes/monorepo.git//terraform/modules/gcp/cloud-storages?ref=main"
}

include {
  path = find_in_parent_folders()
}

dependency "data_project" {
  config_path = "${get_parent_terragrunt_dir()}/non-prod/global/data/gcp/project"
}

dependency "project_iam_bindings" {
  config_path = "${get_parent_terragrunt_dir()}/non-prod/global/iam/gcp/project-iam-bindings"
}

dependency "random_string" {
  config_path = "${get_parent_terragrunt_dir()}/non-prod/global/terraform/random/random-string"
}

inputs = {
  cloud_storages = [
    {
      location   = "US"
      name       = "datasets-${dependency.random_string.outputs.result}"
      project_id = dependency.data_project.outputs.project_id
      versioning = true
    }
  ]
}
