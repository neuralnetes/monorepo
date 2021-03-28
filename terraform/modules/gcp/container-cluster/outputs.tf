output "name" {
  value = module.container-cluster.name
}

output "project_id" {
  value = module.container-cluster["project_id"]
}

output "region" {
  value = module.container-cluster.region
}
