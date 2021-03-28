variable "add_cluster_firewall_rules" {
  type    = bool
  default = true
}

variable "create_service_account" {
  type    = bool
  default = false
}

variable "enable_private_nodes" {
  type    = bool
  default = true
}

variable "firewall_inbound_ports" {
  type    = list(string)
  default = []
}

variable "ip_range_pods" {
  type = string
}

variable "ip_range_services" {
  type = string
}

variable "kubernetes_version" {
  type    = string
  default = "latest"
}

variable "master_authorized_networks" {
  type    = list(object({ cidr_block = string, display_name = string }))
  default = []
}

variable "master_ipv4_cidr_block" {
  type    = string
  default = "192.168.0.0/28"
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

variable "node_pools_tags" {
  type = map(list(string))
  default = {
    all = ["private"]
  }
}

variable "project_id" {
  type = string
}

variable "region" {
  type = string
}

variable "regional" {
  type    = bool
  default = false
}

variable "remove_default_node_pool" {
  type    = bool
  default = true
}

variable "service_account" {
  type = string
}

variable "subnetwork" {
  type = string
}

variable "zones" {
  type    = list(string)
  default = []
}