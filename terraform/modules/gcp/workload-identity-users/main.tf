module "workload-identity-users" {
  for_each                   = local.workload_identity_users_map
  source                     = "github.com/neuralnetes/monorepo.git//terraform/modules/gcp/workload-identity-user?ref=main"
  project_id                 = each.value["project_id"]
  service_account_id         = each.value["service_account_id"]
  kubernetes_service_account = each.value["kubernetes_service_account"]
  kubernetes_namespace       = each.value["kubernetes_namespace"]
}

locals {
  workload_identity_users_map = {
    for workload_identity_user in var.workload_identity_users :
    workload_identity_user["service_account_id"] => workload_identity_user
  }
}