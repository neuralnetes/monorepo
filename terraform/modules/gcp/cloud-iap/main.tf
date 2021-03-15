data "google_project" "project" {
  project_id = var.project_id
}

resource "google_iap_brand" "project_brand" {
  support_email     = var.support_email
  application_title = var.application_title
  project           = data.google_project.project.project_id
}


resource "google_iap_client" "project_client" {
  display_name = var.display_name
  brand        = google_iap_brand.project_brand.name
}