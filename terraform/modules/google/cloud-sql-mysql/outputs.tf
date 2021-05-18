output "mysql" {
  value = google_sql_database_instance.mysql
}

output "default_user" {
  value = google_sql_user.default
}