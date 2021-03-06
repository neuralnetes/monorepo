resource "google_service_networking_connection" "service_networking_connections" {
  for_each                = local.service_networking_connections_map
  provider                = google-beta
  network                 = each.value["network"]
  service                 = each.value["service"]
  reserved_peering_ranges = each.value["reserved_peering_ranges"]
}


locals {
  service_networking_connections_map = {
    for service_networking_connection in var.service_networking_connections :
    service_networking_connection["network"] => service_networking_connection
  }
}