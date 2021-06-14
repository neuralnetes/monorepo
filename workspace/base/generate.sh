#!/bin/bash
ENVRC_PATHS=(
  "${GITHUB_BASE_WORKSPACE}/.envrc-go"
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
