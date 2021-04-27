variable "cluster_name" {
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

variable "network_project" {
  type = string
}

variable "triggers" {
  type = map(string)
}