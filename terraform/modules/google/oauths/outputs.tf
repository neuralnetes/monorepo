output "brands_map" {
  value = google_iap_brand.brands
}

output "clients_map" {
  value     = google_iap_client.clients
  sensitive = true
}
