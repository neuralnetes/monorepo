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
      dataset_id   = "first_rate_data"
      dataset_name = "first_rate_data"
      description  = "first_rate_data"
      project_id   = dependency.data_project.outputs.project_id
      location     = "US"
      tables = [
        {
          table_id = "most_liquid_us_stocks_1500",
          schema   = "${get_terragrunt_dir()}/schema/first_rate_data/most_liquid_us_stocks_1500.json",
          time_partitioning = {
            type                     = "DAY",
            field                    = null
            require_partition_filter = false,
            expiration_ms            = null
          },
          expiration_time = null,
          clustering      = [],
          labels          = {}
        }
      ]
      views                       = []
      delete_contents_on_destroy  = true
      default_table_expiration_ms = null
      dataset_labels              = {}
    }
  ]
}
