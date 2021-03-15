terraform {
  source = "git::git@github.com:neuralnetes/infra-modules//gcp/service-accounts?ref=master"
}

include {
  path = find_in_parent_folders()
}

dependency "project" {
  config_path = "${get_terragrunt_dir()}/../project"
}

dependency "random_string" {
  config_path = "${get_parent_terragrunt_dir()}/non-prod/global/shared/random/random-string"
}

inputs = {
  service_accounts = [
    {
      project_id = dependency.project.outputs.project_id
      name       = "cloud-function-${dependency.random_string.outputs.result}"
      project_roles = [
        "${dependency.project.outputs.project_id}=>roles/storage.admin",
        "${dependency.project.outputs.project_id}=>roles/pubsub.admin",
        "${dependency.project.outputs.project_id}=>roles/cloudfunctions.admin",
        "${dependency.project.outputs.project_id}=>roles/bigquery.admin"
      ]
    }
  ]
}