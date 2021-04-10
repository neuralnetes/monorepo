terraform {
  source = "github.com/neuralnetes/monorepo.git//terraform/modules/gcp/cloud-storage-notifications?ref=main"
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
  config_path = "${get_parent_terragrunt_dir()}/non-prod/global/data/gcp/cloud-storages"
}

dependency "pubsub" {
  config_path = "${get_parent_terragrunt_dir()}/non-prod/global/data/gcp/pubsub"
}

inputs = {
  notifications = [
    for bucket_name in keys(dependency.cloud_storage.outputs.buckets_map) :
    {
      project_id        = dependency.data_project.outputs.project_id
      bucket_name       = bucket_name
      pubsub_topic_name = dependency.pubsub.outputs.topics_map[bucket_name].topic
      custom_attributes = {}
    }
    if contains(keys(dependency.pubsub.outputs.topics_map), bucket_name)
  ]
}