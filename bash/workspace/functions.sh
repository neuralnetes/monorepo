#!/bin/bash
source "${GITHUB_WORKSPACE}/bash/base/functions.sh"
source "${GITHUB_WORKSPACE}/bash/github/functions.sh"
source "${GITHUB_WORKSPACE}/bash/google/functions.sh"
source "${GITHUB_WORKSPACE}/bash/python/functions.sh"
source "${GITHUB_WORKSPACE}/bash/kubernetes/functions.sh"
source "${GITHUB_WORKSPACE}/bash/terraform/functions.sh"
source "${GITHUB_WORKSPACE}/bash/terragrunt/functions.sh"

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
