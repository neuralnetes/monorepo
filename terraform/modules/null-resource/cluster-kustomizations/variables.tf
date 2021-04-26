variable "cluster_kustomizations" {
  type = list(object({
    github_workspace = string
    cluster_name     = string
    compute_project  = string
    iam_project      = string
    network_project  = string
    triggers         = map(string)
  }))
}