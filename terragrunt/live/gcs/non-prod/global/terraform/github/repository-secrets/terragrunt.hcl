terraform {
  source = "github.com/neuralnetes/monorepo.git//terraform/modules/github/repository-secrets?ref=main"
}

include {
  path = find_in_parent_folders()
}

dependency "repositories" {
  config_path = "${get_parent_terragrunt_dir()}/non-prod/global/terraform/github/repositories"
}

dependency "data_project" {
  config_path = "${get_parent_terragrunt_dir()}/non-prod/global/data/gcp/project"
}

dependency "cloud_storage" {
  config_path = "${get_parent_terragrunt_dir()}/non-prod/global/data/gcp/cloud-storage"
}

dependency "random_string" {
  config_path = "${get_parent_terragrunt_dir()}/non-prod/global/terraform/random/random-string"
}

inputs = {
  secrets = flatten([
    [
      //      for repository_secret in [
      //        {
      //          secret_name     = "DATA_PROJECT_ID",
      //          plaintext_value = dependency.data_project.outputs.project_id
      //        },
      //        {
      //          secret_name     = "SOURCE_ARCHIVE_BUCKET_NAME",
      //          plaintext_value = dependency.cloud_storage.outputs.buckets_map["functions-${dependency.random_string.outputs.result}"].name
      //        }
      //        ] : merge(
      //        {
      //          repository = reverse(split("/", dependency.repositories.outputs.repositories_map["neuralnetes/functions"].full_name))[0]
      //        },
      //        repository_secret
      //      )
    ]
  ])
}