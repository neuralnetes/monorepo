#!/bin/bash
mkdir -p "${HOME_LOCAL_BIN}"
export GITHUB_BASE_WORKSPACE="${GITHUB_WORKSPACE}/workspace/base"
export FUNCTION_FILE="${GITHUB_BASE_WORKSPACE}/tmp1"
export ENV_FILE="${GITHUB_BASE_WORKSPACE}/tmp2"
export RESULT_FILE="${GITHUB_BASE_WORKSPACE}/.envrc"
rm -rf "${FUNCTION_FILE}"
rm -rf "${ENV_FILE}"
rm -rf "${RESULT_FILE}"

FUNCTION_PATHS=(
  "${GITHUB_WORKSPACE}/bash/github/functions.sh"
  "${GITHUB_WORKSPACE}/bash/google/functions.sh"
  "${GITHUB_WORKSPACE}/bash/python/functions.sh"
  "${GITHUB_WORKSPACE}/bash/kubernetes/alias.sh"
  "${GITHUB_WORKSPACE}/bash/kubernetes/functions.sh"
  "${GITHUB_WORKSPACE}/bash/terraform/functions.sh"
  "${GITHUB_WORKSPACE}/bash/terragrunt/functions.sh"
)
for envrc in "${FUNCTION_PATHS[@]}"; do
  cat "${envrc}" >>"${FUNCTION_FILE}"
  echo >>"${FUNCTION_FILE}"
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
  cat "${envrc}" >>"${ENV_FILE}"
  echo >>"${FUNCTION_FILE}"
done

cat "${FUNCTION_FILE}" >>"${RESULT_FILE}"
echo >>"${RESULT_FILE}"
cat "${ENV_FILE}" >>"${RESULT_FILE}"

rm -rf "${FUNCTION_FILE}"
rm -rf "${ENV_FILE}"

source "${RESULT_FILE}"

function setup_workspace() {
  setup_gitconfig
  setup_gcloud_macos
  setup_oh_my_zsh
  setup_zshrc
  setup_pyenv
  setup_pyenv_virtualenv
  setup_tfenv
  setup_tgenv
  setup_kubectl
  setup_kustomize
  setup_kubectx
  setup_flux
  setup_mc
}

setup_workspace
