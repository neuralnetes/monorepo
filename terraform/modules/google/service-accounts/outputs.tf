output "service_accounts_map" {
  value = google_service_account.service-accounts
}

output "service_account_datas_map" {
  value = data.google_service_account.service-account-datas
}
