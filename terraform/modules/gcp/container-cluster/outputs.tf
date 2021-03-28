output "container_cluster" {
  sensitive = true
  value     = module.container-cluster
}

output "name" {
  value = module.container-cluster.name
}
