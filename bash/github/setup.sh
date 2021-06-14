#!/bin/bash
set -ex
export GITHUB_BASE_WORKSPACE="${GITHUB_WORKSPACE}/workspace/base"
export GITHUB_BASE_FUNCTION_FILE="${GITHUB_BASE_WORKSPACE}/functions.sh"
export GITHUB_BASE_ENV_FILE="${GITHUB_BASE_WORKSPACE}/.envrc"
rm -rf "${GITHUB_BASE_FUNCTION_FILE}"
rm -rf "${GITHUB_BASE_ENV_FILE}"
bash "${GITHUB_BASE_WORKSPACE}/generate.sh"

export GITHUB_USERNAME_WORKSPACE="${GITHUB_WORKSPACE}/workspace/${GITHUB_USERNAME}"
export GITHUB_USERNAME_ENV_FILE="${GITHUB_USERNAME_WORKSPACE}/.envrc"
source "${GITHUB_BASE_FUNCTION_FILE}"
source "${GITHUB_BASE_ENV_FILE}"
source "${GITHUB_USERNAME_ENV_FILE}"
mkdir -p "${HOME_LOCAL_BIN}"
mkdir -p "${HOME_LOCAL_LOG}"

function setup_workspace() {
  setup_gitconfig
  setup_gcloud
  setup_oh_my_zsh
  setup_zshrc
  setup_pyenv
  setup_pyenv_virtualenv
  setup_tfenv
  setup_tgenv
  setup_kubectl
  setup_kustomize
  setup_flux
  setup_mc
}

setup_workspace
