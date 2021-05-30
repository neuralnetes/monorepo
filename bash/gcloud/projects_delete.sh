#!/bin/bash
SERVICE_PROJECTS=(
  "${IAM_PROJECT}"
  "${SECRET_PROJECT}"
  "${DATA_PROJECT}"
  "${COMPUTE_PROJECT}"
  "${KUBEFLOW_PROJECT}"
)
for project_id in "${SERVICE_PROJECTS[@]}"; do
  gcloud projects delete "${project_id}" -q
done

HOST_PROJECTS=(
  "${NETWORK_PROJECT}"
)
for project_id in "${HOST_PROJECTS[@]}"; do
  bash "${GITHUB_WORKSPACE}/bash/gcloud/gcloud_resource_manager_liens_delete.sh" "${project_id}"
  gcloud projects delete "${project_id}" -q
done

gsutil rm -rf "gs://${GCS_TERRAFORM_REMOTE_STATE_BUCKET}/**/*"
