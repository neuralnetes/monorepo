resource "google_artifact_registry_repository_iam_member" "artifact_registry_repository_iam_members" {
  for_each   = local.artifact_registry_repository_iam_member_map
  provider   = google-beta
  location   = each.value["location"]
  repository = each.value["repository"]
  role       = each.value["role"]
  member     = each.value["member"]
  project    = each.value["project"]
}


locals {
  artifact_registry_repository_iam_member_map = {
    for artifact_registry_repository_iam_member in var.artifact_registry_repository_iam_members :
    artifact_registry_repository_iam_member["name"] => artifact_registry_repository_iam_member
  }
}
