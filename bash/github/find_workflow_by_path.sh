#!/bin/bash
path="${1}"
# https://docs.github.com/en/rest/reference/actions#list-repository-workflows
workflows=$(bash "${GITHUB_WORKSPACE}/bash/github/list_workflows.sh")
workflow=$(echo "${workflows}" | jq -rc --arg path "${path}"  '.workflows[] | select(.path == $path)')
echo "${workflow}"
