output "application_title" {
  value = google_iap_brand.project_brand.application_title
}

output "client_id" {
  value = google_iap_client.project_client.client_id
}

output "client_secret" {
  value = google_iap_client.project_client.secret
}
