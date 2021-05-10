#!/bin/bash
export ZSH="${HOME}/.oh-my-zsh"
export ZSH_THEME="robbyrussell"
export plugins=(
    git
    kubectl
    terraform
    pyenv
    python
    gcloud
    aws
    fzf
    nvm
)
source "${ZSH}/oh-my-zsh.sh"
source "${HOME}/.envrc"
