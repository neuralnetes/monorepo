module "cloud_routers" {
  for_each = local.cloud_routers_map_map
  source   = "github.com/terraform-google-modules/terraform-google-cloud-router.git//?ref=v0.4.0"
  name     = each.value["name"]
  network  = each.value["network"]
  project  = each.value["project"]
  region   = each.value["region"]
  bgp      = each.value["bgp"]
}
locals {
  cloud_routers_map_map = {
    for cloud_router in var.cloud_routers :
    cloud_router["name"] => cloud_router
  }
}