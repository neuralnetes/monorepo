#!/bin/bash
cd "$(dirname "$0")"
PROJECT=${1}
API_SERVICES=(
  "compute.googleapis.com"
  "container.googleapis.com"
  "secretmanager.googleapis.com"
  "serviceusage.googleapis.com"
  "cloudresourcemanager.googleapis.com"
  "cloudbilling.googleapis.com"
  "iam.googleapis.com"
  "admin.googleapis.com"
  "dataflow.googleapis.com"
)
for api_service in "${API_SERVICES[@]}"; do
  gcloud services enable "${api_service}" --project="${PROJECT}" &
done
wait
