resource "github_actions_secret" "secrets" {
  for_each        = local.secrets_map
  plaintext_value = each.value["plaintext_value"]
  repository      = each.value["repository"]
  secret_name     = each.value["secret_name"]
}

locals {
  secrets_map = {
    for secret in var.secrets :
    "${secret["repository"]}/${secret["secret_name"]}" => secret
  }
}
