variable "workload_identity_users" {
  type = list(object({
    project_id                 = string
    service_account_id         = string
    kubernetes_namespace       = string
    kubernetes_service_account = string
  }))
}