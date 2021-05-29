#!/bin/bash
ORGANIZATION=${1}
SERVICE_ACCOUNT_EMAIL=${2}
ROLES=("roles/resourcemanager.projectCreator" "roles/billing.user" "roles/compute.xpnAdmin")
for role in "${ROLES[@]}"; do
  gcloud organizations add-iam-policy-binding \
    "${ORGANIZATION}" \
    --member="serviceAccount:${SERVICE_ACCOUNT_EMAIL}" \
    --role="${role}"
done
