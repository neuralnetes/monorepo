module "vpc" {
  for_each                               = local.vpc_map
  source                                 = "github.com/terraform-google-modules/terraform-google-network.git//modules/vpc?ref=v3.2.2"
  network_name                           = each.value["network_name"]
  project_id                             = each.value["project_id"]
  auto_create_subnetworks                = each.value["auto_create_subnetworks"]
  delete_default_internet_gateway_routes = each.value["delete_default_internet_gateway_routes"]
  shared_vpc_host                        = each.value["shared_vpc_host"]
}

locals {
  vpc_map = {
    for vpc in var.vpc :
    vpc["network_name"] => vpc
  }
}
