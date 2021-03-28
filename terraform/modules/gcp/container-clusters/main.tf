module "container-clusters" {
  for_each                              = local.container_clusters_map
  source                                = "github.com/neuralnetes/monorepo.git//terraform/modules/gcp/container-cluster?ref=main"
  ip_range_pods = each.value["ip_range_pods"]
  ip_range_services = each.value["ip_range_services"]
  name = each.value["name"]
  network = each.value["network"]
  network_project_id = each.value["network_project_id"]
  node_pools = each.value["node_pools"]
  project_id = each.value["project_id"]
  service_account = each.value["service_account"]
  subnetwork = each.value["subnetwork"]
}

module "container-cluster-auths" {
  for_each     = module.container-clusters
  source       = "github.com/terraform-google-modules/terraform-google-kubernetes-engine.git//modules/auth?ref=v14.0.1"
  project_id   = each.value["project_id"]
  cluster_name = each.value["name"]
  location     = each.value["region"]
}

locals {
  container_clusters_map = {
    for container_cluster in var.container_clusters :
    container_cluster["name"] => container_cluster
  }
}