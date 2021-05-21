variable "cluster_name" {
  type = string
}

variable "github_client_id" {
  type = string
}

variable "github_client_secret" {
  type = string
}

variable "github_owner" {
  type = string
}

variable "github_workspace" {
  type = string
}

variable "compute_project" {
  type = string
}

variable "iam_project" {
  type = string
}

variable "kubeflow_project" {
  type = string
}

variable "network_project" {
  type = string
}

variable "secret_project" {
  type = string
}

variable "triggers" {
  type = map(string)
}

variable "istio_ingressgateway_load_balancer_ip" {
  type = string
}
