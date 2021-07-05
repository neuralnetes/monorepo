terraform {
  source = "github.com/neuralnetes/monorepo.git//terraform/modules/google/cloud-storage-notifications?ref=main"
}

include {
  path = find_in_parent_folders()
}

dependency "data_project" {
  config_path = "${get_parent_terragrunt_dir()}/non-prod/global/data/google/project"
}

dependency "cloud_storages" {
  config_path = "${get_parent_terragrunt_dir()}/non-prod/global/data/google/cloud-storages"
}

dependency "pubsub" {
  config_path = "${get_parent_terragrunt_dir()}/non-prod/global/data/google/pubsub"
}

inputs = {
  notifications = [
    for bucket_name, bucket in dependency.cloud_storages.outputs.cloud_storages_map :
    {
      project_id        = dependency.data_project.outputs.project_id
      bucket_name       = bucket_name
      pubsub_topic_name = dependency.pubsub.outputs.topics_map[bucket_name].topic
      custom_attributes = {}
    }
  ]
}