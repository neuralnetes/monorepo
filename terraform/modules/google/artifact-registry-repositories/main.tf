resource "google_artifact_registry_repository" "artifact_registry_repositories" {
  for_each      = local.artifact_registry_repositories_map
  provider      = google-beta
  location      = each.value["location"]
  repository_id = each.value["repository_id"]
  description   = each.value["description"]
  format        = each.value["format"]
  project       = each.value["project"]
}

locals {
  artifact_registry_repositories_map = {
    for artifact_registry_repository in var.artifact_registry_repositories :
    artifact_registry_repository["repository_id"] => artifact_registry_repository
  }
}
