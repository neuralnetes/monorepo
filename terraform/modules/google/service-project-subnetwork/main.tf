locals {
  api_service_account_email = format(
    "${data.google_project.service_project.number}@cloudservices.gserviceaccount.com",
  )
  project_service_account_email = "project-service-account@${data.google_project.service_project.project_id}.iam.gserviceaccount.com"
}

data "google_project" "service_project" {
  project_id = var.service_project_id
}

data "google_project" "host_project" {
  project_id = var.host_project_id
}

data "google_compute_subnetwork" "subnetwork" {
  self_link = var.subnetwork_self_link
}

resource "google_compute_shared_vpc_service_project" "service_project" {
  provider        = google-beta
  host_project    = data.google_project.host_project.project_id
  service_project = data.google_project.service_project.project_id
}

resource "google_project_iam_member" "members" {
  for_each = toset([
    local.api_service_account_email,
    local.project_service_account_email,
  ])
  project = data.google_project.host_project.project_id
  role    = "roles/compute.networkUser"
  member  = "serviceAccount:${each.value}"
}

resource "google_compute_subnetwork_iam_member" "members" {
  for_each = toset([
    local.api_service_account_email,
    local.project_service_account_email,
  ])
  provider   = google-beta
  subnetwork = data.google_compute_subnetwork.subnetwork.self_link
  role       = "roles/compute.networkUser"
  region     = var.region
  project    = data.google_project.host_project.project_id
  member     = "serviceAccount:${each.value}"
}
