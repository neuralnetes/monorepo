variable "network_project" {
  default = ""
}
variable "network_name" {
  default = ""
}

data "google_compute_network" "network" {
  provider = google-beta
  project  = var.network_project
  name     = var.network_name
}
resource "google_compute_address" "" {
  provider = google-beta

  name          = "${data.google_compute_network.network.name}-private-01"
  purpose       = "VPC_PEERING"
  address_type  = "INTERNAL"
  prefix_length = 16
  network       = data.google_compute_network.network.id
}

resource "google_service_networking_connection" "private_vpc_connection" {
  provider = google-beta

  network                 = google_compute_network.private_network.id
  service                 = "servicenetworking.googleapis.com"
  reserved_peering_ranges = [google_compute_global_address.private_ip_address.name]
}

resource "random_id" "db_name_suffix" {
  byte_length = 4
}

resource "google_sql_database_instance" "instance" {
  provider = google-beta

  name   = "private-instance-${random_id.db_name_suffix.hex}"
  region = "us-central1"

  depends_on = [google_service_networking_connection.private_vpc_connection]

  settings {
    tier = "db-f1-micro"
    ip_configuration {
      ipv4_enabled    = false
      private_network = google_compute_network.private_network.id
    }
  }
}