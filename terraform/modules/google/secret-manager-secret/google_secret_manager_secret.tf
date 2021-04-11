resource "google_secret_manager_secret" "secret" {
  project   = data.google_project.project.project_id
  secret_id = var.secret_id
  replication {
    automatic = var.replication["automatic"]
  }
}
