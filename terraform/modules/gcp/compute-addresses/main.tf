resource "google_compute_address" "regional_addresses" {
  provider     = google-beta
  for_each     = local.regional_addresses_map
  name         = each.value["name"]
  purpose      = each.value["purpose"]
  address_type = each.value["address_type"]
  labels       = each.value["labels"]
  subnetwork   = each.value["subnetwork"]
}

resource "google_compute_global_address" "global_addresses" {
  provider      = google-beta
  for_each      = local.global_addresses_map
  name          = each.value["name"]
  purpose       = each.value["purpose"]
  address_type  = each.value["address_type"]
  prefix_length = each.value["prefix_length"]
  network       = each.value["network"]
}

locals {
  regional_addresses_map = {
    for regional_address in var.regional_addresses :
    regional_address["name"] => regional_address
  }
  global_addresses_map = {
    for global_address in var.global_addresses :
    global_address["name"] => global_address
  }
}

