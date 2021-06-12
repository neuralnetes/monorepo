locals {
  identity_group_memberships_map = {
    for membership in var.identity_group_memberships :
    membership["name"] => membership
  }
}

resource "google_cloud_identity_group_membership" "identity_group_memberships" {
  for_each = local.identity_group_memberships_map
  provider = google-beta
  group    = each.value["group"]
  roles {
    name = each.value["roles_name"]
  }
  member_key {
    id = each.value["member_key_id"]
  }
}
