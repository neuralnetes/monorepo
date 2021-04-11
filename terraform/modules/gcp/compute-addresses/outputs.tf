output "regional_addresses_map" {
  value = google_compute_address.regional_addresses
}

output "global_addresses_map" {
  value = google_compute_global_address.global_addresses
}