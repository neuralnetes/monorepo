variable "name" {
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
  type = string
}

variable "cert_organization" {
  type = string
}