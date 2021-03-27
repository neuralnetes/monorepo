#!/bin/bash
cd "$(dirname "$0")"
WORKFLOW_ID="${1}"
INPUTS="${2}"
# https://docs.github.com/en/rest/reference/actions#create-a-workflow-dispatch-event
curl -s \
  -X POST \
  -H "Accept: application/vnd.github.v3+json" \
  -H "Authorization: token ${GH_TOKEN}" \
  "https://api.github.com/repos/${GITHUB_REPOSITORY}/actions/workflows/${WORKFLOW_ID}/dispatches" \
  -d "${INPUTS}"
