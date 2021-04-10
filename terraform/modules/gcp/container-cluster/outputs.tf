output "cluster_name" {
  value = module.container-cluster.name
}

output "project_id" {
  value = data.google_project.project
}

output "location" {
  value = module.container-cluster.location
}