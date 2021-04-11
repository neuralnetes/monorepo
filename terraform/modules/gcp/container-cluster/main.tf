module "container-cluster" {
  source                     = "github.com/terraform-google-modules/terraform-google-kubernetes-engine.git//modules/beta-private-cluster?ref=v14.1.0"
  create_service_account     = var.create_service_account
  enable_private_nodes       = var.enable_private_nodes
  ip_range_pods              = var.ip_range_pods
  ip_range_services          = var.ip_range_services
  kubernetes_version         = var.kubernetes_version
  master_authorized_networks = var.master_authorized_networks
  master_ipv4_cidr_block     = var.master_ipv4_cidr_block
  name                       = var.name
  network                    = var.network
  network_project_id         = var.network_project_id
  node_pools                 = var.node_pools
  node_pools_tags            = var.node_pools_tags
  project_id                 = var.project_id
  region                     = var.region
  regional                   = var.regional
  remove_default_node_pool   = var.remove_default_node_pool
  service_account            = var.service_account
  subnetwork                 = var.subnetwork
  zones                      = var.zones
  node_pools_oauth_scopes = {
    all = [
      "https://www.googleapis.com/auth/cloud-platform",
      "https://www.googleapis.com/auth/ndev.clouddns.readwrite"
    ]
  }
}
