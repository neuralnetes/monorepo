#!/bin/bash
export ZSH="${HOME}/.oh-my-zsh"
export ZSH_THEME="robbyrussell"
export plugins=(
    direnv
    git
    fzf
    nvm
)
source "${ZSH}/oh-my-zsh.sh"
