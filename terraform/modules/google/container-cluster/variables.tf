# required
variable "cluster_autoscaling" {
  type = object({
    enabled             = bool
    autoscaling_profile = string
    min_cpu_cores       = number
    max_cpu_cores       = number
    min_memory_gb       = number
    max_memory_gb       = number
  })
}

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

variable "region" {
  type = string
}

variable "service_account" {
  type = string
}

variable "subnetwork" {
  type = string
}

# optional
variable "add_cluster_firewall_rules" {
  type    = bool
  default = false
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

variable "initial_node_count" {
  type    = number
  default = 1
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

variable "node_pools_oauth_scopes" {
  type = map(list(string))
  default = {
    all = [
      "https://www.googleapis.com/auth/cloud-platform",
    ]
  }
}

variable "node_pools_tags" {
  type = map(list(string))
  default = {
    all = []
  }
}

variable "regional" {
  type    = bool
  default = false
}

variable "remove_default_node_pool" {
  type    = bool
  default = true
}

variable "zones" {
  type    = list(string)
  default = []
}
