variable "vpc" {
  type = list(object({
    network_name                           = string
    project_id                             = string
    auto_create_subnetworks                = string
    delete_default_internet_gateway_routes = string
    shared_vpc_host                        = string
  }))
}