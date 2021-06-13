#!/bin/bash
STATUS=$1
export GCS_TERRAFORM_REMOTE_STATE_BUCKET_LOGS="gs://${GCS_TERRAFORM_REMOTE_STATE_BUCKET}/${GITHUB_SHA}/logs.txt"
export GCS_TERRAFORM_REMOTE_STATE_BUCKET_ENV="gs://${GCS_TERRAFORM_REMOTE_STATE_BUCKET}/${GITHUB_SHA}/env.txt"
TEXT=$(
  jq -n \
    --arg logs "${GCS_TERRAFORM_REMOTE_STATE_BUCKET_LOGS}" \
    --arg env "${GCS_TERRAFORM_REMOTE_STATE_BUCKET_ENV}" \
    --arg run "${GITHUB_ACTIONS_RUN_URL}" \
    --arg status "${STATUS}" \
    '{
      "type": "github_actions",
      "data": {
        "status": $status,
        "logs": $logs,
        "run": $run,
        "env": $env
      }
    }'
)
export SLACK_WEBHOOK_DATA=$(
  jq -n \
    --argjson text "${TEXT}" \
    '{
      "text": ($text | tostring)
    }'
)
env >"${GITHUB_WORKSPACE}/env.txt"
gsutil cp "${GITHUB_WORKSPACE}/logs.txt" "${GCS_TERRAFORM_REMOTE_STATE_BUCKET_LOGS}"
gsutil cp "${GITHUB_WORKSPACE}/env.txt" "${GCS_TERRAFORM_REMOTE_STATE_BUCKET_ENV}"
bash "${GITHUB_WORKSPACE}/bash/slack/webhook.sh"
