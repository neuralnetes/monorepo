module "cloud-dns" {
  for_each                           = local.cloud_dns_map
  source                             = "github.com/terraform-google-modules/terraform-google-cloud-dns.git?ref=v3.1.0"
  project_id                         = each.value["project_id"]
  type                               = each.value["type"]
  name                               = each.value["name"]
  domain                             = each.value["domain"]
  private_visibility_config_networks = each.value["type"] == "private" ? each.value["private_visibility_config_networks"] : null
}

locals {
  cloud_dns_map = {
    for dns in var.cloud_dns :
    dns["name"] => dns
  }
}