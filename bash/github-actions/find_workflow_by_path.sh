#!/bin/bash
cd "$(dirname "$0")"
path="${1}"
# https://docs.github.com/en/rest/reference/actions#list-repository-workflows
workflows=$(./list_workflows.sh)
workflow=$(echo "${workflows}" | jq -rc --arg path "${path}"  '.workflows[] | select(.path == $path)')
echo "${workflow}"
