module "secret-manager-secrets" {
  for_each    = local.secret_manager_secrets_map
  source      = "github.com/neuralnetes/monorepo.git//terraform/modules/gcp/secret-manager-secret?ref=main"
  project_id  = each.value["project_id"]
  secret_id   = each.value["secret_id"]
  secret_data = each.value["secret_data"]
  replication = each.value["replication"]
}

locals {
  secret_manager_secrets_map = {
    for secret_manager_secret in var.secret_manager_secrets :
    secret_manager_secret["secret_id"] => secret_manager_secret
  }
}