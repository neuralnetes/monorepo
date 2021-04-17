resource "google_service_account_iam_member" "iam_members" {
  for_each           = local.service_account_iam_members_map
  service_account_id = each.value["service_account_id"]
  role               = each.value["role"]
  member             = each.value["member"]
}

variable "service_account_iam_members" {
  type = list(object({
    service_account_id = string
    role               = string
    member             = string
  }))
}

locals {
  service_account_iam_members_map = {
    for i, service_account_iam_member in var.service_account_iam_members :
    i => service_account_iam_member
  }
}

output "service_account_iam_members_map" {
  value = google_service_account_iam_member.iam_members
}