module "biquery-datasets" {
  for_each   = local.bigquery_datasets_map
  source     = "github.com/neuralnetes/monorepo.git//terraform/modules/google/bigquery-dataset?ref=main"
  dataset_id = each.value["dataset_id"]
  project_id = each.value["project_id"]
  location   = each.value["location"]
  tables     = each.value["tables"]
}

locals {
  bigquery_datasets_map = {
    for dataset in var.bigquery_datasets :
    dataset["dataset_id"] => dataset
  }
}
