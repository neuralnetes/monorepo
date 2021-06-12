locals {
  identity_groups_map = {
    for group in var.identity_groups :
    group["display_name"] => group
  }
}

resource "google_cloud_identity_group" "identity_groups" {
  for_each     = local.identity_groups_map
  provider     = google-beta
  display_name = each.value["display_name"]
  parent       = each.value["parent"]
  group_key {
    id = each.value["group_key_id"]
  }
  labels = {
    "cloudidentity.googleapis.com/groups.discussion_forum" = ""
  }
}
