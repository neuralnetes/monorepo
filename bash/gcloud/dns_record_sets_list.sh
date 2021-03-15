#!/bin/bash
# ./dns_record_sets_list "${GCP_PROJECT_ID}" '["us-central1-a", "us-central1-b", "us-central1-c"]'
project_id="${1}"
dns_zones="{2}"
for dns_zone in $(echo "${dns_zones}" | jq -r '.[]'); do
  gcloud dns record-sets list \
    --project="${project_id}" \
    --zone "${dns_zones}" \
    --format json \
    | jq -r
done
