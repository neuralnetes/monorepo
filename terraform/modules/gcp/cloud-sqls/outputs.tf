output "mysqls_map" {
  value     = module.mysqls
  sensitive = true
}

output "postgresqls_map" {
  value     = module.postgresqls
  sensitive = true
}