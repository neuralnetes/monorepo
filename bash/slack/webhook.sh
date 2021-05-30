#!/bin/bash
echo "${SLACK_WEBHOOK_DATA}" | jq
curl -X POST -H 'Content-type: application/json' \
  --data "${SLACK_WEBHOOK_DATA}" \
  "${SLACK_WEBHOOK}"
