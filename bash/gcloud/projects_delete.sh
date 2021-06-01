#!/bin/bash
source "${GITHUB_WORKSPACE}/bash/gcloud/functions.sh"
SERVICE_PROJECTS=$(get_service_projects)
for project_id in "${SERVICE_PROJECTS[@]}"; do
  gcloud projects delete "${project_id}" -q
done

HOST_PROJECTS=(get_host_projects)
for project_id in "${HOST_PROJECTS[@]}"; do
  bash "${GITHUB_WORKSPACE}/bash/gcloud/gcloud_resource_manager_liens_delete.sh" "${project_id}"
  gcloud projects delete "${project_id}" -q
done

gsutil rm -rf "gs://${GCS_TERRAFORM_REMOTE_STATE_BUCKET}/**/*"
