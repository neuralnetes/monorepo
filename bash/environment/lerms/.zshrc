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
source "${ZSH}/oh-my-zsh.sh"
export GOPATH="${HOME}/go"
export GOBIN="${GOPATH}/bin"
export EDITOR="code --wait"
export KUBE_EDITOR="${EDITOR}"
export GITHUB_WORKSPACE="${GOPATH}/src/github.com/${GITHUB_REPOSITORY}"
export GITHUB_WORKSPACE_BIN="${GITHUB_WORKSPACE}/bin"
export PATH="${GITHUB_WORKSPACE_BIN}:${GOBIN}:${PATH}"
export GITHUB_ORGANIZATION="neuralnetes"
export GITHUB_REPOSITORY="${GITHUB_ORGANIZATION}/monorepo"
export GITHUB_SHA=$(cd "${GITHUB_WORKSPACE}" && git rev-parse HEAD)
export GITHUB_REF=$(cd "${GITHUB_WORKSPACE}" && git branch --show-current)
export GITHUB_TOKEN=""
mkdir -p "${GITHUB_WORKSPACE_BIN}"
ln -fs "${GITHUB_WORKSPACE}/bash/environment/lerms"/.* "${GITHUB_WORKSPACE}"
ln -fs "${GITHUB_WORKSPACE}/bash/environment/lerms"/* "${GITHUB_WORKSPACE}"
source "${GITHUB_WORKSPACE}/.function"
source "${GITHUB_WORKSPACE}/.alias"
direnv allow "${GITHUB_WORKSPACE}/.envrc"
