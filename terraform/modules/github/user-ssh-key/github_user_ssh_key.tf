resource "github_user_ssh_key" "ssh_key" {
  title = var.title
  key   = tls_private_key.key.public_key_openssh
}
