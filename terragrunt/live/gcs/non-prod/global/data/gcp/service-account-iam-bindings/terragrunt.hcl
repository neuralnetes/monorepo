terraform {
  source = "git::git@github.com:neuralnetes/infra-modules//gcp/service-account-iam-bindings?ref=master"
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
      service_account = "${dependency.project.outputs.project_id}@appspot.gserviceaccount.com"
      bindings = {
        for role in [
          "roles/iam.serviceAccountUser",
        ] :
        role => [
          "serviceAccount:${dependency.auth.outputs.email}",
        ]
      }
      project = dependency.project.outputs.project_id
    }
  ]
}