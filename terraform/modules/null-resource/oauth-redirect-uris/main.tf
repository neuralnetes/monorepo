resource "null_resource" "redirect_uris" {
  provisioner "local-exec" {
    interpreter = ["bash", "-c"]
    command     = ["${var.github_workspace}/bash/gcloud/redirect_uris.sh"]
    environment = {
      IAM_PROJECT          = var.iam_project
      GOOGLE_CLIENT_ID     = var.google_client_id
      GOOGLE_CLIENT_SECRET = var.google_client_secret
      OAUTH_REDIRECT_URIS  = var.oauth_redirect_uris
    }
  }
  triggers = var.triggers
}
