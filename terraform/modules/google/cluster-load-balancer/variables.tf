variable "name" {
  type = string
}

variable "network_project" {
  type = string
}

variable "cluster_project" {
  type = string
}

variable "cluster_name" {
  type = string
}

variable "cluster_location" {
  type = string
}

variable "cert_dns_names" {
  type = list(string)
}

variable "cert_common_name" {
  default = string
}

variable "cert_organization" {
  default = string
}