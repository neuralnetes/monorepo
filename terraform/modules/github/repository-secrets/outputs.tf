output "secrets_map" {
  value     = github_actions_secret.secrets
  sensitive = true
}
