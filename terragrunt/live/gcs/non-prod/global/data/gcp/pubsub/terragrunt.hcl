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

dependency "cloud_storages" {
  config_path = "${get_parent_terragrunt_dir()}/non-prod/global/data/gcp/cloud-storages"
}

dependency "random_string" {
  config_path = "${get_parent_terragrunt_dir()}/non-prod/global/terraform/random/random-string"
}

inputs = {
  topics = flatten([
    [
      for cloud_storage in values(dependency.cloud_storages.outputs.cloud_storages_map) :
      {
        topic              = cloud_storage["bucket"]
        project_id         = dependency.data_project.outputs.project_id
        push_subscriptions = []
        pull_subscriptions = []
      }
    ]
  ])
}
