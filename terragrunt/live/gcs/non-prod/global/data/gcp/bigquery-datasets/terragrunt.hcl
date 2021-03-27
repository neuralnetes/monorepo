terraform {
  source = "git::git@github.com:neuralnetes/monorepo.git//terraform/modules/gcp/bigquery-dataset?ref=main"
}

include {
  path = find_in_parent_folders()
}

dependency "project" {
  config_path = "${get_terragrunt_dir()}/../project"
}

dependency "project_iam_bindings" {
  config_path = "${get_parent_terragrunt_dir()}/non-prod/global/iam/gcp/project-iam-bindings"
}

dependency "random_string" {
  config_path = "${get_parent_terragrunt_dir()}/non-prod/global/shared/random/random-string"
}

inputs = {
  datasets = [
    //    {
    //      dataset_id   = "first_rate_data"
    //      dataset_name = "first_rate_data"
    //      description  = "first_rate_data"
    //      project_id   = dependency.project.outputs.project_id
    //      location     = "US"
    //      tables = [
    //        {
    //          table_id = "most_liquid_us_stocks_1500",
    //          schema   = "${get_terragrunt_dir()}/schema/first_rate_data/most_liquid_us_stocks_1500.json",
    //          time_partitioning = {
    //            type                     = "DAY",
    //            field                    = null
    //            require_partition_filter = false,
    //            expiration_ms            = null
    //          },
    //          expiration_time = null,
    //          clustering      = [],
    //          labels          = {}
    //        }
    //      ]
    //      views                       = []
    //      external_tables             = []
    //      delete_contents_on_destroy  = true
    //      default_table_expiration_ms = null
    //      dataset_labels              = {}
    //      access                      = []
    //    }
  ]
}
