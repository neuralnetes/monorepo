terraform {
  source = "github.com/neuralnetes/monorepo.git//terraform/modules/google/secret-manager-secrets?ref=main"
}

include {
  path = find_in_parent_folders()
}

dependency "secret_project" {
  config_path = "${get_parent_terragrunt_dir()}/non-prod/global/secret/google/project"
}

dependency "project_iam_bindings" {
  config_path = "${get_parent_terragrunt_dir()}/non-prod/global/iam/google/project-iam-bindings"
}

dependency "random_string" {
  config_path = "${get_parent_terragrunt_dir()}/non-prod/global/terraform/random/random-string"
}

inputs = {
  secret_manager_secrets = [
    {
      project_id  = dependency.secret_project.outputs.project_id
      secret_id   = "random-${dependency.random_string.outputs.result}"
      secret_data = dependency.random_string.outputs.result
      replication = {
        automatic = true
      }
    }
  ]
}