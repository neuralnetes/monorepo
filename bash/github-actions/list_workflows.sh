#!/bin/bash
# https://docs.github.com/en/rest/reference/actions#list-repository-workflows
curl -s \
  -H "Accept: application/vnd.github.v3+json" \
  -H "Authorization: token ${GH_TOKEN}" \
  "https://api.github.com/repos/${GITHUB_REPOSITORY}/actions/workflows"
