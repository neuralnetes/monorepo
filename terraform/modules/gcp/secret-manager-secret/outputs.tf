output "secret" {
  value = google_secret_manager_secret.secret
}

output "version" {
  value = google_secret_manager_secret_version.version
}