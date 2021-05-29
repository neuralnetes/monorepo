module "cluster_load_balancers" {
  for_each          = local.cluster_load_balances_map
  source            = "github.com/neuralnetes/monorepo.git//terraform/modules/google/http-load-balancer?ref=main"
  name              = each.value["name"]
  network_project   = each.value["network_project"]
  cluster_project   = each.value["cluster_project"]
  cluster_name      = each.value["cluster_name"]
  cluster_location  = each.value["cluster_location"]
  cert_dns_names    = each.value["cert_dns_names"]
  cert_common_name  = each.value["cert_common_name"]
  cert_organization = each.value["cert_organization"]
}

locals {
  cluster_load_balances_map = {
    for cluster_load_balancer in var.cluster_load_balancers :
    cluster_load_balancer["name"] => cluster_load_balancer
  }
}