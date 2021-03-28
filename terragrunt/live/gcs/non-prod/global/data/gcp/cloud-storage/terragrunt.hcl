terraform {
  source = "github.com/terraform-google-modules/terraform-google-cloud-storage.git//?ref=v1.7.2"
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
  project_id = dependency.data_project.outputs.project_id
  location   = "US"
  names = [
    for name_prefix in [
      "datasets",
      "functions"
    ] : "${name_prefix}-${dependency.random_string.outputs.result}"
  ]
  prefix = ""
}
