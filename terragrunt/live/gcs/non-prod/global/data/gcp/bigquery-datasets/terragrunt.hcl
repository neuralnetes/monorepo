terraform {
  source = "github.com/neuralnetes/monorepo.git//terraform/modules/gcp/bigquery-datasets?ref=main"
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

dependency "random_string" {
  config_path = "${get_parent_terragrunt_dir()}/non-prod/global/terraform/random/random-string"
}

inputs = {
  bigquery_datasets = [
    {
      dataset_id = "first_rate_data"
      project_id = dependency.data_project.outputs.project_id
      location   = "US"
      tables = [
        {
          table_id = "most_liquid_us_stocks_1500",
          schema   = file("${get_terragrunt_dir()}/schema/first_rate_data/most_liquid_us_stocks_1500.json"),
          time_partitioning = {
            type                     = "DAY",
            field                    = null
            require_partition_filter = false,
            expiration_ms            = null
          },
          range_partitioning = null
          expiration_time    = null,
          clustering         = [],
          labels             = {}
        }
      ]
      dataset_labels = {}
    }
  ]
}
