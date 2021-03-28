output "container_clusters_map" {
  value = module.container-clusters
}

output "container_cluster_auths_map" {
  sensitive = true
  value     = module.container-cluster-auths
}