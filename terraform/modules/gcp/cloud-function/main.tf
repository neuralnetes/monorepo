data "google_project" "project" {
  project_id = var.project_id
}

data "google_storage_bucket_object" "source_archive_bucket_object" {
  bucket = var.source_archive_bucket_name
  name   = var.source_archive_bucket_object_name
}

data "google_service_account" "service_account" {
  account_id = var.service_account_email
  project    = data.google_project.project.project_id
}

resource "google_cloudfunctions_function" "function" {
  project               = data.google_project.project.project_id
  source_archive_bucket = data.google_storage_bucket_object.source_archive_bucket_object.bucket
  source_archive_object = data.google_storage_bucket_object.source_archive_bucket_object.name
  service_account_email = data.google_service_account.service_account.email

  name                  = var.name
  region                = var.region
  runtime               = var.runtime
  description           = var.description
  available_memory_mb   = var.available_memory_mb
  max_instances         = var.max_instances
  entry_point           = var.entry_point
  environment_variables = var.environment_variables

  event_trigger {
    event_type = var.event_trigger["event_type"]
    resource   = var.event_trigger["resource"]

    failure_policy {
      retry = var.event_trigger_failure_policy_retry
    }
  }
}
