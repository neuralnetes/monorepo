output "images_map" {
  value = data.google_compute_image.images
}

output "compute_instances_map" {
  value = google_compute_instance.instances
}
