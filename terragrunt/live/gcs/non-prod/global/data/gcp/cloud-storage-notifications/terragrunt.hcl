terraform {
  source = "git::git@github.com:neuralnetes/monorepo.git//terraform/modules/gcp/cloud-storage-notifications?ref=main"
}

include {
  path = find_in_parent_folders()
}

dependency "project" {
  config_path = "${get_terragrunt_dir()}/../project"
}

dependency "project_iam_bindings" {
  config_path = "${get_parent_terragrunt_dir()}/non-prod/global/iam/gcp/project_iam_bindings"
}

dependency "cloud_storage" {
  config_path = "${get_terragrunt_dir()}/../cloud-storage"
}

dependency "pubsub" {
  config_path = "${get_terragrunt_dir()}/../pubsub"
}

inputs = {
  notifications = [
    for bucket_name in keys(dependency.cloud_storage.outputs.buckets_map) :
    {
      project_id        = dependency.project.outputs.project_id
      bucket_name       = bucket_name
      pubsub_topic_name = dependency.pubsub.outputs.topics_map[bucket_name].topic
      custom_attributes = {
        test = "test"
      }
    }
    if contains(keys(dependency.pubsub.outputs.topics_map), bucket_name)
  ]
}