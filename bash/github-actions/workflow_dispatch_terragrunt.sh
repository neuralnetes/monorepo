#!/bin/bash
cd "$(dirname "$0")"
request_json=$(
  jq -n \
    --arg ref "${GITHUB_REF}" \
    --arg iam "${IAM}" \
    --arg secret "${SECRET}" \
    --arg network "${NETWORK}" \
    --arg data "${DATA}" \
    --arg compute "${COMPUTE}" \
    --arg shared "${SHARED}" \
    --arg terragrunt_working_dir "${TERRAGRUNT_WORKING_DIR}" \
    --arg terragrunt_command "${TERRAGRUNT_COMMAND}" \
    '
      {
        "ref": $ref,
        "inputs": {
          "network": $network,
          "secret": $secret,
          "iam": $iam,
          "data": $data,
          "compute": $compute,
          "shared": $shared,
          "terragrunt_working_dir": $terragrunt_working_dir,
          "terragrunt_command": $terragrunt_command
        }
      }
    '
)
echo "${request_json}" | jq
workflow=$(./find_workflow_by_path.sh  ".github/workflows/terragrunt.yaml")
workflow_id=$(echo "${workflow}" | jq '.id')
./workflow_dispatch.sh "${workflow_id}" "${request_json}"
