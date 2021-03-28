terraform {
  source = "github.com/neuralnetes/monorepo.git//terraform/modules/gcp/project-data?ref=main"
}

include {
  path = find_in_parent_folders()
}

inputs = {
  project = get_env("GCP_PROJECT_ID")
  activate_apis = [
    "cloudresourcemanager.googleapis.com",
    "cloudbilling.googleapis.com",
    "compute.googleapis.com",
    "container.googleapis.com",
    "servicemanagement.googleapis.com",
    "serviceusage.googleapis.com",
    "iam.googleapis.com",
    "admin.googleapis.com",
  ]
}
