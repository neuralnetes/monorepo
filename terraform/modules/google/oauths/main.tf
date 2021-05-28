resource "google_iap_brand" "brands" {
  for_each          = local.oauths_map
  application_title = each.value["application_title"]
  support_email     = each.value["support_email"]
  project           = each.value["project"]
}

resource "google_iap_client" "clients" {
  for_each     = google_iap_brand.brands
  brand        = each.value.id
  display_name = each.value.application_title
}

locals {
  oauths_map = {
    for oauth in var.oauths :
    oauth["application_title"] => oauth
  }
}
