terraform {
  source = "git::git@github.com:neuralnetes/infra-modules//gcp/secret-manager-secrets?ref=master"
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
  secret_manager_secrets = [
    {
      project_id  = dependency.project.outputs.project_id
      secret_id   = "random-${dependency.random_string.outputs.result}"
      secret_data = dependency.random_string.outputs.result
      replication = {
        automatic = true
      }
    }
  ]
}