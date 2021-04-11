resource "google_service_account_iam_member" "member" {
  service_account_id = data.google_service_account.service_account.account_id
  role               = "roles/iam.workloadIdentityUser"
  member             = "serviceAccount:${var.project_id}.svc.id.goog[${var.kubernetes_namespace}/${var.kubernetes_service_account}]"
}
