output "container_cluster_auths_map" {
  value     = module.container-cluster-auths
  sensitive = true
}

output "kubeconfig_raws_map" {
  value     = local.kubeconfig_raws_map
  sensitive = true
}
