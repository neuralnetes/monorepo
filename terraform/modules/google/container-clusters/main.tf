module "container-clusters" {
  for_each                   = local.container_clusters_map
  source                     = "github.com/neuralnetes/monorepo.git//terraform/modules/google/container-cluster?ref=main"
  ip_range_pods              = each.value["ip_range_pods"]
  ip_range_services          = each.value["ip_range_services"]
  kubernetes_version         = each.value["kubernetes_version"]
  master_authorized_networks = each.value["master_authorized_networks"]
  master_ipv4_cidr_block     = each.value["master_ipv4_cidr_block"]
  name                       = each.value["name"]
  network                    = each.value["network"]
  network_project_id         = each.value["network_project_id"]
  node_pools                 = each.value["node_pools"]
  node_pools_oauth_scopes    = each.value["node_pools_oauth_scopes"]
  node_pools_tags            = each.value["node_pools_tags"]
  project_id                 = each.value["project_id"]
  region                     = each.value["region"]
  regional                   = each.value["regional"]
  create_service_account     = each.value["create_service_account"]
  service_account            = each.value["service_account"]
  subnetwork                 = each.value["subnetwork"]
  zones                      = each.value["zones"]
  grant_registry_access      = each.value["grant_registry_access"]
  registry_project_ids       = each.value["registry_project_ids"]
}

locals {
  container_clusters_map = {
    for container_cluster in var.container_clusters :
    container_cluster["name"] => container_cluster
  }
}