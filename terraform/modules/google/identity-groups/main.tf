variable "groups" {
  type = list(object({
    display_name = string
    parent       = string
    group_key_id = string
  }))
}

locals {
  groups_map = {
    for group in var.groups :
    group["display_name"] => group
  }
}

resource "google_cloud_identity_group" "groups" {
  for_each     = local.groups_map
  display_name = each.value["display_name"]
  parent       = each.value["parent"]
  group_key {
    id = each.value["group_key_id"]
  }
  labels = {
    "cloudidentity.googleapis.com/groups.discussion_forum" = ""
  }
}

output "groups_map" {
  value = google_cloud_identity_group.groups
}
