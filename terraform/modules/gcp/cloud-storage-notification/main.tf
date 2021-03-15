data "google_project" "project" {
  project_id = var.project_id
}

data "google_storage_project_service_account" "gcs_account" {
  project = data.google_project.project.project_id
}

data "google_pubsub_topic" "topic" {
  project = data.google_project.project.project_id
  name    = var.pubsub_topic_name
}

resource "google_storage_notification" "notification" {
  bucket         = var.bucket_name
  payload_format = "JSON_API_V1"
  topic          = data.google_pubsub_topic.topic.id
  event_types = [
    "OBJECT_FINALIZE",
    "OBJECT_METADATA_UPDATE",
    "OBJECT_DELETE",
    "OBJECT_ARCHIVE"
  ]
  custom_attributes = var.custom_attributes
  depends_on        = [google_pubsub_topic_iam_binding.binding]
}

resource "google_pubsub_topic_iam_binding" "binding" {
  project = data.google_project.project.project_id
  topic   = data.google_pubsub_topic.topic.id
  role    = "roles/pubsub.publisher"
  members = ["serviceAccount:${data.google_storage_project_service_account.gcs_account.email_address}"]
}
