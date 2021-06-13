#!/bin/bash
function setup_pyenv() {
  export PYENV_ROOT="$HOME/.pyenv"
  rm -rf "${PYENV_ROOT}"
  git clone https://github.com/pyenv/pyenv.git "${PYENV_ROOT}"
  eval "$(pyenv init --path)"
  eval "$(pyenv init -)"
}

function setup_pyenv_virtualenv() {
  PYTHON_VERSION=$(cat "${GITHUB_WORKSPACE}/.python-version")
  pyenv install "${PYTHON_VERSION}"
  git clone https://github.com/pyenv/pyenv-virtualenv.git $(pyenv root)/plugins/pyenv-virtualenv
  eval "$(pyenv virtualenv-init -)"
  source "${HOME}/.zshrc"
  pyenv virtualenv -f "${PYTHON_VERSION}" "${PYTHON_VERSION}-monorepo"
  pyenv activate "${PYTHON_VERSION}-monorepo"
}
