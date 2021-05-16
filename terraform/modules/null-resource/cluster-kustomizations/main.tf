module "cluster-kustomizations" {
  for_each             = local.cluster_kustomizations_map
  source               = "github.com/neuralnetes/monorepo.git//terraform/modules/null-resource/cluster-kustomization?ref=main"
  github_client_id     = each.value["github_client_id"]
  github_client_secret = each.value["github_client_secret"]
  github_owner         = each.value["github_owner"]
  github_workspace     = each.value["github_workspace"]
  cluster_name         = each.value["cluster_name"]
  compute_project      = each.value["compute_project"]
  iam_project          = each.value["iam_project"]
  kubeflow_project     = each.value["kubeflow_project"]
  network_project      = each.value["network_project"]
  secret_project       = each.value["secret_project"]
  triggers             = each.value["triggers"]
}


locals {
  cluster_kustomizations_map = {
    for cluster_kustomization in var.cluster_kustomizations :
    cluster_kustomization["cluster_name"] => cluster_kustomization
  }
}