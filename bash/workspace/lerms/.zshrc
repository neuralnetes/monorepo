#!/bin/bash
export EDITOR="code --wait"
export KUBE_EDITOR="${EDITOR}"
export PATH="${GOBIN}:${PATH}"
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
mkdir -p "${GOBIN}"
export GITHUB_ORGANIZATION="neuralnetes"
export GITHUB_REPOSITORY="${GITHUB_ORGANIZATION}/monorepo"
export GITHUB_WORKSPACE="${GOPATH}/src/github.com/${GITHUB_REPOSITORY}"
export GITHUB_WORKSPACE="${GOPATH}/src/github.com/${GITHUB_REPOSITORY}"
export GITHUB_USER="lerms"
export GITHUB_USER_WORKSPACE="${GITHUB_WORKSPACE}/bash/workspace/${GITHUB_USER}"
mkdir -p "${GITHUB_WORKSPACE}"
mkdir -p "${GITHUB_USER_WORKSPACE}"
ln -fs "${GITHUB_USER_WORKSPACE}"/.envrc* "${GITHUB_WORKSPACE}"
ln -fs "${GITHUB_USER_WORKSPACE}"/.* "${HOME}"
ln -fs "${GITHUB_USER_WORKSPACE}"/* "${HOME}"
source "${GITHUB_USER_WORKSPACE}/.function"
source "${GITHUB_USER_WORKSPACE}/.alias"
