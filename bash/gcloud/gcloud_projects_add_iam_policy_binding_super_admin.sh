#!/bin/bash
PROJECT=${1}
SERVICE_ACCOUNT_EMAIL=${2}
ROLES=("roles/owner" "roles/storage.admin" "roles/secretmanager.admin")
for role in "${ROLES[@]}"; do
  gcloud projects add-iam-policy-binding \
    "${PROJECT}" \
    --member="serviceAccount:${SERVICE_ACCOUNT_EMAIL}" \
    --role="${role}"
done
