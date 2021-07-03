resource "google_compute_address" "regional_addresses" {
  provider     = google-beta
  for_each     = local.regional_addresses_map
  project      = each.value["project"]
  name         = each.value["name"]
  address_type = each.value["address_type"]
  region       = each.value["region"]
  purpose      = each.value["address_type"] == "EXTERNAL" ? null : each.value["purpose"]
  subnetwork   = each.value["address_type"] == "EXTERNAL" ? null : each.value["subnetwork"]
}

resource "google_compute_global_address" "global_addresses" {
  provider      = google-beta
  for_each      = local.global_addresses_map
  project       = each.value["project"]
  name          = each.value["name"]
  address_type  = each.value["address_type"]
  purpose       = each.value["address_type"] == "EXTERNAL" ? null : each.value["purpose"]
  prefix_length = each.value["address_type"] == "EXTERNAL" ? null : each.value["prefix_length"]
  network       = each.value["address_type"] == "EXTERNAL" ? null : each.value["network"]
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

