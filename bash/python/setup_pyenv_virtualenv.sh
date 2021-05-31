#!/bin/bash
PYTHON_VERSION_FILE="${GITHUB_WORKSPACE}/.python-version"
PYTHON_VERSION=$(cat "${PYTHON_VERSION_FILE}")
git clone https://github.com/pyenv/pyenv-virtualenv.git "${HOME}/.pyenv/plugins/pyenv-virtualenv"
pyenv virtualenv -f "${PYTHON_VERSION}" "${PYTHON_VERSION}"
