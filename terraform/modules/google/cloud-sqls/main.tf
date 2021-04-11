module "mysqls" {
  for_each                             = local.mysqls_map
  source                               = "github.com/neuralnetes/monorepo.git//terraform/modules/google/cloud-sql-mysql?ref=main"
  name                                 = each.value["name"]
  tier                                 = each.value["tier"]
  region                               = each.value["region"]
  database_version                     = each.value["database_version"]
  project                              = each.value["project"]
  ip_configuration_private_network     = each.value["ip_configuration_private_network"]
  ip_configuration_ipv4_enabled        = each.value["ip_configuration_ipv4_enabled"]
  ip_configuration_authorized_networks = each.value["ip_configuration_authorized_networks"]
  ip_configuration_require_ssl         = each.value["ip_configuration_require_ssl"]
}

module "postgresqls" {
  for_each         = local.postgresqls_map
  source           = "github.com/terraform-google-modules/terraform-google-sql-db.git//modules/postgresql?ref=v4.5.0"
  database_version = each.value["database_version"]
  name             = each.value["name"]
  project_id       = each.value["project_id"]
  region           = each.value["region"]
  zone             = each.value["zone"]
  ip_configuration = each.value["ip_configuration"]
}

locals {
  mysqls_map = {
    for mysql in var.mysqls :
    mysql["name"] => mysql
  }
  postgresqls_map = {
    for postgresql in var.postgresqls :
    postgresql["name"] => postgresql
  }
}