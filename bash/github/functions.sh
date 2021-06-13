#!/bin/bash
function get_github_ref() {
  git branch --show-current "$(get_github_workspace)"
}

function get_github_sha() {
  git rev-parse HEAD "$(get_github_workspace)"
}

function get_github_sha_short() {
  git rev-parse --short HEAD "$(get_github_workspace)"
}

function get_git_config_global() {
  git config --global --list |
    cat
}

function get_github_username_workspace() {
  echo "$(get_github_workspace)/workspace/$(get_github_username)"
}

function get_github_name() {
  git config --global user.name
}

function get_github_email() {
  git config --global user.email
}

function get_github_username() {
  git config --global user.username
}

function get_github_workspace() {
  git rev-parse --show-toplevel
}

function get_github_repository() {
  git remote get-url origin |
    tr ":" "\n" |
    tail -n 1 |
    cut -d '.' -f 1
}

function get_github_owner() {
  get_github_repository |
    cut -d '/' -f 1
}

function setup_gitconfig() {
  cat <<EOF >"${HOME}/.gitconfig"
[user]
  email = ${GITHUB_EMAIL}
  name = ${GITHUB_NAME}
  username = ${GITHUB_USERNAME}
[core]
  editor = \$EDITOR
[init]
  defaultBranch = main
EOF
}

function setup_oh_my_zsh() {
  bash -c "$(wget https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh -O -)"
}

function setup_zshrc() {
  cat <<EOF >"${HOME}/.zshrc"
export ZSH="\${HOME}/.oh-my-zsh"
export ZSH_THEME="robbyrussell"
export plugins=(
    git
    fzf
    kubectl
    gcloud
)
source "\${ZSH}/oh-my-zsh.sh"
source "\${HOME}/.envrc"
EOF
}

