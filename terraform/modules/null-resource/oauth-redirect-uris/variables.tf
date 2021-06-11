variable "github_workspace" {}
variable "google_client_id" {}
variable "google_client_secret" {}
variable "oauth_redirect_uris" {
  type = list(string)
}
variable "iam_project" {}
variable "triggers" {}
