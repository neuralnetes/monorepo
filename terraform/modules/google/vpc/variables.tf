variable "vpc" {
  type = list(object({
    auto_create_subnetworks                = string
    delete_default_internet_gateway_routes = string
    network_name                           = string
    project_id                             = string
    routing_mode                           = string
    shared_vpc_host                        = string
  }))
}