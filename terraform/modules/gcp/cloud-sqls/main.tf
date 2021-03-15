module "mysqls" {
  for_each         = local.mysqls_map
  source           = "git::git@github.com:terraform-google-modules/terraform-google-sql-db.git//modules/mysql?ref=v4.5.0"
  database_version = each.value["database_version"]
  name             = each.value["name"]
  project_id       = each.value["project_id"]
  region           = each.value["region"]
  zone             = each.value["zone"]
  ip_configuration = each.value["ip_configuration"]
}

module "postgresqls" {
  for_each         = local.postgresqls_map
  source           = "git::git@github.com:terraform-google-modules/terraform-google-sql-db.git//modules/postgresql?ref=v4.5.0"
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