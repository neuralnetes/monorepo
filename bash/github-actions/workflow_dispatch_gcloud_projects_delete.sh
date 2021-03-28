#!/bin/bash
cd "$(dirname "$0")"
request_json=$(
  jq -n \
    --arg ref "${GITHUB_REF:-master}" \
    --arg iam "${IAM:-true}" \
    --arg secret "${SECRET:-true}" \
    --arg network "${NETWORK:-true}" \
    --arg data "${DATA:-true}" \
    --arg compute "${COMPUTE:-true}" \
    --arg shared "${TERRAFORM:-true}" \
    '
      {
        "ref": $ref,
        "inputs": {
          "network": $network,
          "secret": $secret,
          "iam": $iam,
          "data": $data,
          "compute": $compute,
          "shared": $shared
        }
      }
    '
)
workflow=$(./find_workflow_by_path.sh ".github/workflows/gcloud-projects-delete.yaml")
workflow_id=$(echo "${workflow}" | jq '.id')
./workflow_dispatch.sh "${workflow_id}" "${request_json}"
