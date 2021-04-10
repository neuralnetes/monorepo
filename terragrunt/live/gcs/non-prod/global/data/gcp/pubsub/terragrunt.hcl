terraform {
  source = "github.com/neuralnetes/monorepo.git//terraform/modules/gcp/pubsub?ref=main"
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

dependency "cloud_storage" {
  config_path = "${get_parent_terragrunt_dir()}/non-prod/global/data/gcp/cloud-storage"
}

dependency "random_string" {
  config_path = "${get_parent_terragrunt_dir()}/non-prod/global/terraform/random/random-string"
}

inputs = {
  topics = flatten([
    [
      for bucket_name in keys(dependency.cloud_storage.outputs.buckets_map) :
      {
        topic              = bucket_name
        project_id         = dependency.data_project.outputs.project_id
        push_subscriptions = []
        pull_subscriptions = []
      }
    ],
    [
      {
        topic              = "first-rate-data-${dependency.random_string.outputs.result}"
        project_id         = dependency.data_project.outputs.project_id
        push_subscriptions = []
        pull_subscriptions = []
      }
    ]
  ])
}
