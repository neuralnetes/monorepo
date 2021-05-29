output "load_balancer" {
  value = module.load_balancer
}

output "instance_groups" {
  value = data.google_compute_instance_group.instance_groups
}

output "instances" {
  value = data.google_compute_instance.instances
}

output "http" {
  value = google_compute_instance_group_named_port.http
}

output "https" {
  value = google_compute_instance_group_named_port.https
}