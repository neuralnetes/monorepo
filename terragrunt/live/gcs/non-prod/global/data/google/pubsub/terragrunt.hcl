terraform {
  source = "github.com/neuralnetes/monorepo.git//terraform/modules/google/pubsubs?ref=main"
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

inputs = {
  topics = [
    for bucket_name in keys(dependency.cloud_storages.outputs.cloud_storages_map) :
    {
      topic              = bucket_name
      project_id         = dependency.data_project.outputs.project_id
      push_subscriptions = []
      pull_subscriptions = []
    }
  ]
}
