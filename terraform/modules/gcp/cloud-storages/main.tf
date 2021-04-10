module "cloud-storages" {
  source     = "github.com/terraform-google-modules/terraform-google-cloud-storage.git//?ref=v1.7.2"
  for_each   = local.cloud_storages_map
  project_id = each.value["project_id"]
  location   = each.value["location"]
  names = [
    each.value["name"]
  ]
  versioning = {
    "${each.value["name"]}" = each.value["versioning"]
  }
  prefix = ""
}


locals {
  cloud_storages_map = {
    for cloud_storage in var.cloud_storages :
    cloud_storage["name"] => cloud_storage
  }
}