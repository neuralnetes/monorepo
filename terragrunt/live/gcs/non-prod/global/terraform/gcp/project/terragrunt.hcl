terraform {
  source = "github.com/neuralnetes/monorepo.git//terraform/modules/gcp/project-data?ref=main"
}

include {
  path = find_in_parent_folders()
}

inputs = {
  project_id = get_env("GCP_PROJECT_ID")
  activate_apis = [
    "admin.googleapis.com",
    "cloudbilling.googleapis.com",
    "cloudresourcemanager.googleapis.com",
    "compute.googleapis.com",
    "container.googleapis.com",
    "iam.googleapis.com",
    "servicemanagement.googleapis.com",
    "servicenetworking.googleapis.com",
    "serviceusage.googleapis.com",
    "sqladmin.googleapis.com"
  ]
}
