#!/bin/bash
cd "$(dirname "$0")"
PROJECTS=$(gcloud projects list --format=json | jq -rc  '.[]')

projects=$(echo "${PROJECTS}" | jq -rc 'select(.projectId | contains("compute"))')
project_ids=$(echo "${projects}" | jq -rc '.projectId')
for project_id in ${project_ids}; do
  gcloud projects delete "${project_id}" -q
done
gsutil -m -q  rm -rf  "gs://${GCS_TERRAFORM_REMOTE_STATE_BUCKET}/non-prod/global/compute/**/*"
gsutil -m -q  rm -rf  "gs://${GCS_TERRAFORM_REMOTE_STATE_BUCKET}/non-prod/us-central1/compute/**/*"

projects=$(echo "${PROJECTS}" | jq -rc 'select(.projectId | contains("data"))')
project_ids=$(echo "${projects}" | jq -rc '.projectId')
for project_id in ${project_ids}; do
  gcloud projects delete "${project_id}" -q
done
gsutil -m -q  rm -rf  "gs://${GCS_TERRAFORM_REMOTE_STATE_BUCKET}/non-prod/global/data/**/*"

projects=$(echo "${PROJECTS}" | jq -rc 'select(.projectId | contains("network"))')
project_ids=$(echo "${projects}" | jq -rc '.projectId')
for project_id in ${project_ids}; do
  ./gcloud_resource_manager_liens_delete.sh "${project_id}"
  gcloud projects delete "${project_id}" -q
done
gsutil -m -q  rm -rf  "gs://${GCS_TERRAFORM_REMOTE_STATE_BUCKET}/non-prod/global/network/**/*"
gsutil -m -q  rm -rf  "gs://${GCS_TERRAFORM_REMOTE_STATE_BUCKET}/non-prod/us-central1/network/**/*"

projects=$(echo "${PROJECTS}" | jq -rc 'select(.projectId | contains("secret"))')
project_ids=$(echo "${projects}" | jq -rc '.projectId')
for project_id in ${project_ids}; do
  gcloud projects delete "${project_id}" -q
done
gsutil -m -q  rm -rf  "gs://${GCS_TERRAFORM_REMOTE_STATE_BUCKET}/non-prod/global/secret/**/*"

projects=$(echo "${PROJECTS}" | jq -rc 'select(.projectId | contains("iam"))')
project_ids=$(echo "${projects}" | jq -rc '.projectId')
for project_id in ${project_ids}; do
  gcloud projects delete "${project_id}" -q
done
gsutil -m -q  rm -rf  "gs://${GCS_TERRAFORM_REMOTE_STATE_BUCKET}/non-prod/global/iam/**/*"

gsutil -m -q  rm -rf  "gs://${GCS_TERRAFORM_REMOTE_STATE_BUCKET}/non-prod/global/terraform/**/*"
gsutil -m -q  rm -rf  "gs://${GCS_TERRAFORM_REMOTE_STATE_BUCKET}/**/*"
