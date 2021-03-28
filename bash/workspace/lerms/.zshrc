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
source "${HOME}/.function"
source "${HOME}/.alias"
