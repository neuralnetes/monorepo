output "public_key_openssh" {
  value     = tls_private_key.key.public_key_openssh
  sensitive = true
}

output "private_key_pem" {
  value     = tls_private_key.key.private_key_pem
  sensitive = true
}

output "title" {
  value = GH_USER_ssh_key.ssh_key.title
}
