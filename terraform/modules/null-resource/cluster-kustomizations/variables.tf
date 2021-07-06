variable "cluster_kustomizations" {
  type = list(object({
    github_client_id                      = string
    github_client_secret                  = string
    github_owner                          = string
    github_workspace                      = string
    cluster_name                          = string
    iam_project                           = string
    kubeflow_project                      = string
    secret_project                        = string
    network_project                       = string
    istio_ingressgateway_load_balancer_ip = string
    triggers                              = map(string)
  }))
}