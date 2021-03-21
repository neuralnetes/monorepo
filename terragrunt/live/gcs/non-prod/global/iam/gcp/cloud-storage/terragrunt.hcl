terraform {
  source = "git::git@github.com:terraform-google-modules/terraform-google-cloud-storage.git?ref=v1.7.2"
}

include {
  path = find_in_parent_folders()
}

dependency "project" {
  config_path = "${get_terragrunt_dir()}/../project"
}

dependency "project_iam_bindings" {
  config_path = "${get_terragrunt_dir()}/../project-iam-bindings"
}

dependency "random_string" {
  config_path = "${get_parent_terragrunt_dir()}/non-prod/global/shared/random/random-string"
}

inputs = {
  project_id = dependency.project.outputs.project_id
  location   = "US"
  names = [
    for name_prefix in [
      "datasets",
      "functions"
    ] : "${name_prefix}-${dependency.random_string.outputs.result}"
  ]
  prefix = ""
}
