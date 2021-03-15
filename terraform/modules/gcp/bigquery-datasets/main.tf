module "datasets" {
  for_each                   = local.datasets_map
  source                     = "git::git@github.com:terraform-google-modules/terraform-google-bigquery.git//?ref=v4.5.0"
  dataset_id                 = each.value["dataset_id"]
  project_id                 = each.value["project_id"]
  location                   = each.value["location"]
  delete_contents_on_destroy = each.value["delete_contents_on_destroy"]
  tables                     = each.value["tables"]
  views                      = each.value["views"]
  external_tables            = each.value["external_tables"]
}

locals {
  datasets_map = {
    for dataset in var.datasets :
    dataset["dataset_id"] => dataset
  }
}
