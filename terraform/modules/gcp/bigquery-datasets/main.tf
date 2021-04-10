module "biquery-datasets" {
  for_each                   = local.bigquery_datasets_map
  source                     = "github.com/terraform-google-modules/terraform-google-bigquery.git//?ref=v5.0.0"
  dataset_id                 = each.value["dataset_id"]
  project_id                 = each.value["project_id"]
  location                   = each.value["location"]
  tables                     = each.value["tables"]
  delete_contents_on_destroy = true
}

locals {
  bigquery_datasets_map = {
    for dataset in var.bigquery_datasets :
    dataset["dataset_id"] => dataset
  }
}
