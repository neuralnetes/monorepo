#!/bin/bash
export ZSH="${HOME}/.oh-my-zsh"
export ZSH_THEME="robbyrussell"
export plugins=(
    direnv
    git
    fzf
    nvm
    kubectl
    gcloud
)
source "${ZSH}/oh-my-zsh.sh"
