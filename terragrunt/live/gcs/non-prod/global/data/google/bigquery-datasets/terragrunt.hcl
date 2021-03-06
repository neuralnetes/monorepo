terraform {
  source = "github.com/neuralnetes/monorepo.git//terraform/modules/google/bigquery-datasets?ref=main"
}

include {
  path = find_in_parent_folders()
}

dependency "data_project" {
  config_path = "${get_parent_terragrunt_dir()}/non-prod/global/data/google/project"
}

inputs = {
  bigquery_datasets = [
    {
      dataset_id = "first_rate_data"
      project_id = dependency.data_project.outputs.project_id
      location   = "US"
      tables = [
        {
          table_id           = "most_liquid_us_stocks_1500",
          schema             = file("${get_terragrunt_dir()}/schema/first_rate_data/most_liquid_us_stocks_1500.json"),
          time_partitioning  = null
          range_partitioning = null
          expiration_time    = null,
          clustering         = null,
          labels             = {}
        }
      ]
      dataset_labels = {}
    }
  ]
}
