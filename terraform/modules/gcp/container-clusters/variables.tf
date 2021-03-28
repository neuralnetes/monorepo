variable "container_clusters" {
  type = list(object({
    add_cluster_firewall_rules = each.value["add_cluster_firewall_rules"]
    create_service_account     = each.value["create_service_account"]
    enable_private_nodes       = each.value["enable_private_nodes"]
    firewall_inbound_ports     = each.value["firewall_inbound_ports"]
    ip_range_pods              = each.value["ip_range_pods"]
    ip_range_services          = each.value["ip_range_services"]
    kubernetes_version         = each.value["kubernetes_version"]
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
    service_account            = each.value["service_account"]
    subnetwork                 = each.value["subnetwork"]
    zones                      = each.value["zones"]
  }))
}