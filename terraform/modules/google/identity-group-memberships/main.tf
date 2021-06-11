variable "memberships" {
  type = list(object({
    group         = string
    roles_name    = string
    member_key_id = string
  }))
}

locals {
  memberships_map = {
    for membership in var.memberships :
    membership["name"] => membership
  }
}

resource "google_cloud_identity_group_membership" "memberships" {
  for_each = local.memberships_map
  group    = each.value["group"]
  roles {
    name = each.value["roles_name"]
  }
  member_key {
    id = each.value["member_key_id"]
  }
}

output "memberships_map" {
  value = google_cloud_identity_group_membership.memberships
}
