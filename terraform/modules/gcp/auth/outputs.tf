# kubeconfig
output "email" {
  value     = data.google_client_openid_userinfo.active.email
  sensitive = true
}

output "access_token" {
  value     = data.google_client_config.provider.access_token
  sensitive = true
}
