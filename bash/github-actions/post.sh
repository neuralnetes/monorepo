#!/bin/bash
STATUS=$1
GCS_TERRAFORM_REMOTE_STATE_BUCKET_LOGS="gs://${GCS_TERRAFORM_REMOTE_STATE_BUCKET}/${GITHUB_SHA}/logs.txt"
GCS_TERRAFORM_REMOTE_STATE_BUCKET_ENV="gs://${GCS_TERRAFORM_REMOTE_STATE_BUCKET}/${GITHUB_SHA}/env.txt"
TEXT=$(
  jq -n \
    --arg logs "${GCS_TERRAFORM_REMOTE_STATE_BUCKET_LOGS}" \
    --arg env "${GCS_TERRAFORM_REMOTE_STATE_BUCKET_ENV}" \
    --arg status "${STATUS}" \
    '{
      "type": "github_actions",
      "data": {
        "status": "$status",
        "logs": $logs,
        "env": $env
      }
    }'
)
SLACK_WEBHOOK_DATA=$(
  jq -n \
    --argjson text "${TEXT}" \
    '{
      "text": ($text | tostring)
    }'
)
echo "${SLACK_WEBHOOK_DATA}" | jq
cat "${GITHUB_ENV}" > "${GITHUB_WORKSPACE}/env.txt"
gsutil cp "${GITHUB_WORKSPACE}/logs.txt" "${GCS_TERRAFORM_REMOTE_STATE_BUCKET_LOGS}"
gsutil cp "${GITHUB_WORKSPACE}/env.txt" "${GCS_TERRAFORM_REMOTE_STATE_BUCKET_ENV}"
bash "${GITHUB_WORKSPACE}/bash/slack/webhook.sh"
