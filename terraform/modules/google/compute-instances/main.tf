data "google_compute_image" "images" {
  for_each = local.compute_instances_map
  project = each.value["image_project"]
  family = each.value["image_family"]
}

resource "google_compute_instance" "instances" {
  for_each = local.compute_instances_map
  machine_type = each.value["machine_type"]
  name = each.value["name"]
  project = each.value["project"]
  zone = each.value["zone"]
  tags = each.value["tags"]
  network_interface {
    network = each.value["network"]
    subnetwork = each.value["subnetwork"]
  }
  boot_disk {
    initialize_params {
      image = data.google_compute_image.images[each.value["name"]].self_link
    }
  }
  service_account {
    email  = each.value["service_account_email"]
    scopes = ["cloud-platform"]
  }
}

locals {
  compute_instances_map = {
    for compute_instance in var.compute_instances:
    compute_instance["name"] => compute_instance
  }
}
