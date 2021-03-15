terraform {
  source = "git::git@github.com:neuralnetes/infra-modules//gcp/project-iam-bindings?ref=master"
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

dependency "auth" {
  config_path = "${get_parent_terragrunt_dir()}/non-prod/global/shared/gcp/auth"
}

locals {
  gcp_gsuite_domain_name = get_env("GCP_GSUITE_DOMAIN_NAME")
}

inputs = {
  bindings = [
    {
      key = "bindings-${dependency.random_string.outputs.result}-01"
      bindings = {
        for project_role in [
          "roles/secretmanager.admin"
        ] :
        project_role => [
          "serviceAccount:${dependency.auth.outputs.email}"
        ]
      }
      projects = [dependency.project.outputs.project_id]
    },
    {
      key = "bindings-${dependency.random_string.outputs.result}-02"
      bindings = {
        for project_role in [
          "roles/editor",
        ] :
        project_role => [
          "group:developers@${local.gcp_gsuite_domain_name}"
        ]
      }
      projects = [dependency.project.outputs.project_id]
    }
  ]
}