module "container-clusters" {
  for_each                   = local.container_clusters_map
  source                     = "github.com/neuralnetes/monorepo.git//terraform/modules/gcp/container-cluster?ref=main"
  add_cluster_firewall_rules = each.value["add_cluster_firewall_rules"]
  autoscaling                = each.value["autoscaling"]
  create_service_account     = each.value["create_service_account"]
  enable_private_nodes       = each.value["enable_private_nodes"]
  firewall_inbound_ports     = each.value["firewall_inbound_ports"]
  ip_range_pods              = each.value["ip_range_pods"]
  ip_range_services          = each.value["ip_range_services"]
  master_authorized_networks = each.value["master_authorized_networks"]
  master_ipv4_cidr_block     = each.value["master_ipv4_cidr_block"]
  name                       = each.value["name"]
  network                    = each.value["network"]
  network_project_id         = each.value["network_project_id"]
  node_pools                 = each.value["node_pools"]
  node_pools_tags            = each.value["node_pools_tags"]
  project_id                 = each.value["project_id"]
  region                     = each.value["region"]
  regional                   = each.value["regional"]
  remove_default_node_pool   = each.value["remove_default_node_pool"]
  service_account            = each.value["service_account"]
  subnetwork                 = each.value["subnetwork"]
  zones                      = each.value["zones"]
}

module "container-cluster-auths" {
  for_each     = module.container-clusters
  source       = "github.com/terraform-google-modules/terraform-google-kubernetes-engine.git//modules/auth?ref=v14.0.1"
  project_id   = each.value["project_id"]
  cluster_name = each.value["name"]
  location     = each.value["region"]
}

locals {
  container_clusters_map = {
    for container_cluster in var.container_clusters :
    container_cluster["name"] => container_cluster
  }
}