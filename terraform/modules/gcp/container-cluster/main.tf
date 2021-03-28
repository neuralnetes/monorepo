
module "container-cluster" {
  source                                = "github.com/terraform-google-modules/terraform-google-kubernetes-engine.git//modules/beta-private-cluster?ref=v14.0.1"
  description                = var.description
  regional                   = var.regional
  region                     = var.region
  zones                      = var.zones
  master_ipv4_cidr_block     = var.master_ipv4_cidr_block
  add_cluster_firewall_rules  = var.add_cluster_firewall_rules
  firewall_inbound_ports  = var.firewall_inbound_ports
  autoscaling                = var.autoscaling
  http_load_balancing        = var.http_load_balancing
  horizontal_pod_autoscaling = var.horizontal_pod_autoscaling
  network_policy             = var.network_policy
  enable_private_endpoint    = var.enable_private_endpoint
  enable_private_nodes       = var.enable_private_nodes
  remove_default_node_pool   = var.remove_default_node_pool
  create_service_account     = var.create_service_account
  node_metadata              = var.node_metadata
}

