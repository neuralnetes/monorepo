variable "ip_range_pods" {
  type = string
}

variable "ip_range_services" {
  type = string
}

variable "name" {
  type = string
}

variable "network" {
  type = string
}

variable "network_project_id" {
  type = string
}

variable "node_pools" {
  type = list(map(string))
}

variable "project_id" {
  type = string
}

variable "service_account" {
  type = string
}

variable "subnetwork" {
  type = string
}

variable "description" {
  type    = string
  default = "cluster"
}

variable "regional" {
  type    = string
  default = false
}

variable "region" {
  type    = string
  default = "us-central1"
}

variable "zones" {
  type    = list(string)
  default = []
}

variable "master_ipv4_cidr_block" {
  type    = string
  default = "192.168.0.0/28"
}

variable "add_cluster_firewall_rules" {
  type    = bool
  default = true
}

variable "firewall_inbound_ports" {
  type    = list(string)
  default = []
}

variable "create_service_account" {
  type    = bool
  default = false
}

variable "node_pools_tags" {
  type = map(list(string))
  default = {
    all               = []
    default-node-pool = []
  }
}

variable "master_authorized_networks" {
  type    = list(object({ cidr_block = string, display_name = string }))
  default = []
}

variable "remove_default_node_pool" {
  type    = bool
  default = true
}

variable "autoscaling" {
  type    = bool
  default = true
}

variable "http_load_balancing" {
  type    = bool
  default = true
}

variable "enable_private_nodes" {
  default = true
}