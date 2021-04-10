output "cluster_name" {
  value = module.container-cluster.name
}

output "project_id" {
  value = var.project_id
}

output "location" {
  value = module.container-cluster.location
}