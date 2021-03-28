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
  type = list(object({
    name         = string
    machine_type = string
    min_count    = number
    max_count    = number
    disk_size_gb = number
    disk_type    = string
    image_type   = string
    preemptible  = bool
  }))
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
  type = string
}
variable "regional" {
  type = string
}
variable "region" {
  type = string
}
variable "zones" {
  type = list(string)
}
variable "master_ipv4_cidr_block" {
  type = string
}
variable "add_cluster_firewall_rules" {
  type = bool
}
variable "firewall_inbound_ports" {
  type = list(string)
}
variable "create_service_account" {
  type = bool
}
variable "node_pools_tags" {}
variable "master_authorized_networks" {}
