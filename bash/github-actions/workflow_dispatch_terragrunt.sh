#!/bin/bash
cd "$(dirname "$0")"
request_json=$(
  jq -n \
    --arg ref "${GITHUB_REF}" \
    --arg terragrunt_working_dir "${TERRAGRUNT_WORKING_DIR}" \
    --arg terragrunt_command "${TERRAGRUNT_COMMAND}" \
    --arg terragrunt_cli_flags "${TERRAGRUNT_CLI_FLAGS}" \
    '
      {
        "ref": $ref,
        "inputs": {
          "terragrunt_working_dir": $terragrunt_working_dir,
          "terragrunt_command": $terragrunt_run_all_command,
          "terragrunt_cli_flags": $terragrunt_cli_flags
        }
      }
    '
)
echo "${request_json}" | jq
workflow=$(./find_workflow_by_path.sh  ".github/workflows/terragrunt.yaml")
workflow_id=$(echo "${workflow}" | jq '.id')
./workflow_dispatch.sh "${workflow_id}" "${request_json}"
