variable "cluster_load_balancers" {
  type = list(object({
    name              = string
    network_project   = string
    cluster_project   = string
    cluster_name      = string
    cluster_location  = string
    cert_dns_names    = list(string)
    cert_common_name  = string
    cert_organization = string
  }))
}
