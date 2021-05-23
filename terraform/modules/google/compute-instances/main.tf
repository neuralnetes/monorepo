data "google_compute_image" "images" {
  for_each = local.compute_instances_map
  project  = each.value["image_project"]
  family   = each.value["image_family"]
}

resource "google_compute_instance" "instances" {
  for_each                = local.compute_instances_map
  machine_type            = each.value["machine_type"]
  metadata_startup_script = each.value["metadata_startup_script"]
  name                    = each.key
  project                 = each.value["project"]
  tags                    = each.value["tags"]
  zone                    = each.value["zone"]
  network_interface {
    network    = each.value["network"]
    subnetwork = each.value["subnetwork"]
  }
  boot_disk {
    initialize_params {
      image = data.google_compute_image.images[each.key].self_link
    }
  }
  service_account {
    email  = each.value["service_account_email"]
    scopes = ["cloud-platform"]
  }
}

locals {
  compute_instances_map = {
    for compute_instance in var.compute_instances :
    compute_instance["name"] => compute_instance
  }
}
