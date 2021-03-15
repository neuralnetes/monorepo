terraform {
  source = "git::git@github.com:neuralnetes/monorepo.git//terraform/modules/gcp/pubsub?ref=main"
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

dependency "cloud_storage" {
  config_path = "${get_terragrunt_dir()}/../cloud-storage"
}

dependency "random_string" {
  config_path = "${get_parent_terragrunt_dir()}/non-prod/global/shared/random/random-string"
}

inputs = {
  topics = flatten([
    [
      for bucket_name in keys(dependency.cloud_storage.outputs.buckets_map) :
      {
        topic              = "gcs-${bucket_name}"
        project_id         = dependency.project.outputs.project_id
        push_subscriptions = []
        pull_subscriptions = []
      }
    ],
    [
      {
        topic              = "test-${dependency.random_string.outputs.result}"
        project_id         = dependency.project.outputs.project_id
        push_subscriptions = []
        pull_subscriptions = []
      },
      {
        topic              = "first-rate-data-${dependency.random_string.outputs.result}"
        project_id         = dependency.project.outputs.project_id
        push_subscriptions = []
        pull_subscriptions = []
      }
    ]
  ])
}
