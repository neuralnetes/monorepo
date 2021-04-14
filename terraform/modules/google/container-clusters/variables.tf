variable "container_clusters" {
  type = list(object({
    firewall_inbound_ports = list(string)
    ip_range_pods          = string
    ip_range_services      = string
    kubernetes_version     = string
    master_authorized_networks = list(object({
      cidr_block   = string,
      display_name = string
    }))
    master_ipv4_cidr_block  = string
    name                    = string
    network                 = string
    network_project_id      = string
    node_pools              = list(map(string))
    node_pools_oauth_scopes = map(list(string))
    node_pools_tags         = map(list(string))
    project_id              = string
    region                  = string
    regional                = bool
    service_account         = string
    subnetwork              = string
    zones                   = list(string)
  }))
}