resource "google_sql_database_instance" "mysql" {
  provider         = google-beta
  project          = var.project
  name             = var.name
  region           = var.region
  database_version = var.database_version
  settings {
    tier = var.tier
    ip_configuration {
      ipv4_enabled    = var.ip_configuration_ipv4_enabled
      private_network = var.ip_configuration_private_network
      dynamic "authorized_networks" {
        for_each = var.ip_configuration_authorized_networks
        content {
          value = authorized_networks.value["value"]
          name  = authorized_networks.value["name"]
        }
      }
      require_ssl = var.ip_configuration_require_ssl
    }
  }
}