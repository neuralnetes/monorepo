variable "cluster_kustomizations" {
  type = list(object({
    github_client_id     = string
    github_client_secret = string
    github_owner         = string
    github_workspace     = string
    cluster_name         = string
    compute_project      = string
    iam_project          = string
    kubeflow_project     = string
    network_project      = string
    triggers             = map(string)
  }))
}