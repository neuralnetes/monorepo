#!/bin/bash
function setup_tfenv() {
  TFENV_ROOT="${HOME}/.tfenv"
  if [[ ! -d "${TFENV_ROOT}" ]]; then
    git clone https://github.com/tfutils/tfenv.git "${TFENV_ROOT}"
    ln -fs "${TFENV_ROOT}/bin"/* "${HOME}/.local/bin"
    tfenv install
  fi
}

function update_terraform_version() {
  tfenv list-remote \
    | tail -n +2  \
    | sed '/-alpha/d' \
    | sed '/-beta/d' \
    | head -n 1 \
      > "${GITHUB_WORKSPACE}/.terraform-version"
}
