#!/bin/bash
cd "$(dirname "$0")"
organization_json=$(gcloud organizations list --format=json | jq -r 'first')
gsuite_domain_name=$(echo "${organization_json}" | jq -r '.displayName')
organization_id=$(echo "${organization_json}" | jq -r '.name | split("/") | last')
roles=(
  "roles/resourcemanager.organizationAdmin"
  "roles/serviceusage.serviceUsageAdmin"
  "roles/billing.creator"
  "roles/compute.xpnAdmin"
)
for role in "${roles[@]}"; do
  gcloud organizations add-iam-policy-binding \
    "${organization_id}" \
    --member="group:super.administrators@${gsuite_domain_name}" \
    --role="${role}"
done