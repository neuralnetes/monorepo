data "google_project" "project" {
  project_id = var.project_id
}

resource "google_project_service" "services" {
  for_each = toset(var.activate_apis)
  project = data.google_project.project.project_id
  service = each.value
}
