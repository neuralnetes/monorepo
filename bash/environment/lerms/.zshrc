#!/bin/bash
export ZSH="${HOME}/.oh-my-zsh"
export ZSH_THEME="robbyrussell"
export plugins=(
    git
    kubectl
    terraform
    direnv
    pyenv
    python
    gcloud
    aws
    fzf
    nvm
)
export GOPATH="${HOME}/go"
export GOBIN="${GOPATH}/bin"
export EDITOR="code --wait"
export KUBE_EDITOR="${EDITOR}"
export HOME_BIN="${HOME}/bin"
export GITHUB_ORGANIZATION="neuralnetes"
export GITHUB_REPOSITORY="${GITHUB_ORGANIZATION}/monorepo"
export GITHUB_WORKSPACE="${GOPATH}/src/github.com/${GITHUB_REPOSITORY}"
export GITHUB_WORKSPACE_BIN="${GITHUB_WORKSPACE}/bin"
export GITHUB_SHA=$(cd "${GITHUB_WORKSPACE}" && git rev-parse HEAD)
export GITHUB_REF=$(cd "${GITHUB_WORKSPACE}" && git branch --show-current)
export PATH="${GITHUB_WORKSPACE_BIN}:${HOME_BIN}:${GOBIN}:${PATH}"
mkdir -p "${GOBIN}"
mkdir -p "${HOME_BIN}"
mkdir -p "${GITHUB_WORKSPACE_BIN}"
ln -fs "${GITHUB_WORKSPACE}/bash/environment/lerms"/.* "${GITHUB_WORKSPACE}"
ln -fs "${GITHUB_WORKSPACE}/bash/environment/lerms"/* "${GITHUB_WORKSPACE}"
ln -fs "${GITHUB_WORKSPACE}"/.* "${HOME}"
ln rm -rf "${HOME}/.git"
ln -fs "${GITHUB_WORKSPACE}"/* "${HOME}"
source "${ZSH}/oh-my-zsh.sh"
source "${GITHUB_WORKSPACE}/.function"
source "${GITHUB_WORKSPACE}/.alias"
direnv allow "${GITHUB_WORKSPACE}/.envrc-secret"
direnv allow "${GITHUB_WORKSPACE}/.envrc-public"
direnv allow "${GITHUB_WORKSPACE}/.envrc"
