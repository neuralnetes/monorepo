#!/bin/bash
cd "$(dirname "$0")"
request_json=$(
  jq -n \
    --arg ref "${GITHUB_REF:-master}" \
    --arg terragrunt_working_dir "${TERRAGRUNT_WORKING_DIR:-./live/gcs/non-prod}" \
    --arg terragrunt_run_all_command "${TERRAGRUNT_RUN_ALL_COMMAND:-apply}" \
    --arg iam "${IAM:-true}" \
    --arg secret "${SECRET:-true}" \
    --arg network "${NETWORK:-true}" \
    --arg data "${DATA:-true}" \
    --arg compute "${COMPUTE:-true}" \
    --arg shared "${SHARED:-true}" \
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
          "terragrunt_run_all_command": $terragrunt_run_all_command
        }
      }
    '
)
echo "${request_json}" | jq
#workflow=$(./find_workflow_by_path.sh "${GITHUB_TOKEN}" "${GITHUB_TOKEN}" "${GITHUB_REPOSITORY}" ".github/workflows/terragrunt-run-all.yaml")
#workflow_id=$(echo "${workflow}" | jq '.id')
#./workflow_dispatch.sh "${GITHUB_TOKEN}" "${GITHUB_REPOSITORY}" "${workflow_id}" "${request_json}"
