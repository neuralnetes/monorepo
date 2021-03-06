output "api_service_account_email" {
  value = local.api_service_account_email
}

output "project_service_account_email" {
  value = local.project_service_account_email
}

output "shared_vpc_access" {
  value = module.shared_vpc_access
}
