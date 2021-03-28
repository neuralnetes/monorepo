output "project" {
  value = data.google_project
}
output "project_id" {
  value = data.google_project.project.project_id
}
output "services_map" {
  value = google_project_service.services
}
