resource "google_compute_instance" "instances" {
  for_each = local.compute_instances_map
  machine_type = each.value["machine_type"]
  name = each.value["name"]
  boot_disk {

  }
  network_interface {

  }
}

locals {
  compute_instances_map = {
    for compute_instance in var.compute_instances:
    compute_instance["name"] => compute_instance
  }
}
