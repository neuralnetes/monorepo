module "cloud_nats" {
  for_each                           = local.cloud_nats_map
  source                             = "github.com/terraform-google-modules/terraform-google-cloud-nat.git//?ref=v1.3.0"
  project_id                         = each.value["project_id"]
  router                             = each.value["router"]
  source_subnetwork_ip_ranges_to_nat = each.value["source_subnetwork_ip_ranges_to_nat"]
  subnetworks                        = each.value["subnetworks"]
  region                             = each.value["region"]
}

locals {
  cloud_nats_map = {
    for cloud_nat in var.cloud_nats :
    cloud_nat["name"] => cloud_nat
  }
}