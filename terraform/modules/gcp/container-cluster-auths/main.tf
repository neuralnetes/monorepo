module "container-cluster-auths" {
  for_each     = local.container_cluster_auths_map
  source       = "github.com/terraform-google-modules/terraform-google-kubernetes-engine.git//modules/auth?ref=v14.1.0"
  project_id   = each.value["project_id"]
  cluster_name = each.value["cluster_name"]
  location     = each.value["location"]
}


locals {
  container_cluster_auths_map = {
    for container_cluster_auth in var.container_cluster_auths :
    container_cluster_auth["cluster_name"] => container_cluster_auth
  }
  kubeconfig_raws_map = {
    for container_cluster_auth in module.container-cluster-auths :
    container_cluster_auth.cluster_name => replace(container_cluster_auth.kubeconfig_raw, "\n", "\\n")
  }
}