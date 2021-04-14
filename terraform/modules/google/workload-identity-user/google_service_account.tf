data "google_service_account" "service_account" {
  project = var.project_id
  account_id = var.service_account_id
}