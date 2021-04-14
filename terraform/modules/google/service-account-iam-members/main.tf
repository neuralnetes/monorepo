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
    for service_account_iam_member in var.service_account_iam_members :
    "${service_account_iam_member["service_account_id"]}/${service_account_iam_member["role"]}/${service_account_iam_member["member"]}" => service_account_iam_member
  }
}

output "service_account_iam_members_map" {
  value = google_service_account_iam_member.iam_members
}