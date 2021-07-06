locals {
  api_service_account_email     = "${data.google_project.service_project.number}@cloudservices.gserviceaccount.com"
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

module "shared_vpc_access" {
  source             = "github.com/terraform-google-modules/terraform-google-project-factory.git//modules/shared_vpc_access?ref=v11.0.0"
  host_project_id    = data.google_project.host_project.project_id
  service_project_id = data.google_project.service_project.project_id
  active_apis = [
    //    "compute.googleapis.com",
    "container.googleapis.com"
    //    "dataproc.googleapis.com",
    //    "dataflow.googleapis.com"
  ]
  shared_vpc_subnets = [
    data.google_compute_subnetwork.subnetwork.self_link
  ]
  enable_shared_vpc_service_project = true
}