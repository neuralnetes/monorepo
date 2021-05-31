resource "google_artifact_registry_repository" "artifact_registries" {
  for_each      = local.artifact_registries_map
  provider      = google-beta
  location      = each.value["location"]
  repository_id = each.value["repository_id"]
  description   = each.value["description"]
  format        = each.value["format"]
  project       = each.value["project"]
}

locals {
  artifact_registries_map = {
    for artifact_registry in var.artifact_registries :
    artifact_registry["repository_id"] => artifact_registry
  }
}
