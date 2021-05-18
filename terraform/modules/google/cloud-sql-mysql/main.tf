resource "google_sql_database_instance" "mysql" {
  provider         = google-beta
  project          = var.project_id
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

resource "random_password" "random_password" {
  length = 32
}

resource "google_sql_user" "default" {
  project  = google_sql_database_instance.mysql.project
  instance = google_sql_database_instance.mysql.name
  name     = "default"
  password = random_password.random_password.result
}
