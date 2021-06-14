#!/bin/bash
function lower() {
    echo "$1" | tr '[:upper:]' '[:lower:]'
}

function upper() {
    echo "$1" | tr '[:lower:]' '[:upper:]'
}

function get_os() {
  lower "$(uname)"
}

function post_slack_webhook() {
  curl -X POST -H 'Content-type: application/json' \
    --data "${SLACK_WEBHOOK_DATA}" \
    "${SLACK_WEBHOOK}"
}
