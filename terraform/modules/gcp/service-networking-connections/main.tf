resource "google_service_networking_connection" "private_vpc_connection" {
  for_each = local.service_networking_connections_map
  provider = google-beta
  network                 = each.value["network"]
  service                 = each.value["service"]
  reserved_peering_ranges = each.value["reserved_peering_ranges"]
}

variable "service_networking_connections" {
  default = []
  type = list(object({
    network                 = string
    service                 = string
    reserved_peering_ranges = list(string)
  }))
}

locals {
  service_networking_connections_map = {
    for service_networking_connection in var.service_networking_connections:
    service_networking_connection["network"] => service_networking_connection
  }
}