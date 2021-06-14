#!/bin/bash
FUNCTION_PATHS=(
  "bash/base/functions.sh"
  "bash/github/functions.sh"
  "bash/google/functions.sh"
  "bash/python/functions.sh"
  "bash/kubernetes/functions.sh"
  "bash/terraform/functions.sh"
  "bash/terragrunt/functions.sh"
)

for functions in "${FUNCTION_PATHS[@]}"; do
  echo "source \"\${GITHUB_WORKSPACE}/${functions}\"" >>"${GITHUB_BASE_FUNCTION_FILE}"
  echo >>"${GITHUB_BASE_FUNCTION_FILE}"
done

ENVRC_PATHS=(
  "${GITHUB_BASE_WORKSPACE}/.envrc-python"
  "${GITHUB_BASE_WORKSPACE}/.envrc-grafana"
  "${GITHUB_BASE_WORKSPACE}/.envrc-kubernetes"
  "${GITHUB_BASE_WORKSPACE}/.envrc-terragrunt"
  "${GITHUB_BASE_WORKSPACE}/.envrc-github"
  "${GITHUB_BASE_WORKSPACE}/.envrc-google"
)
for envrc in "${ENVRC_PATHS[@]}"; do
  cat "${envrc}" >>"${GITHUB_BASE_ENV_FILE}"
  echo >>"${GITHUB_BASE_ENV_FILE}"
done

