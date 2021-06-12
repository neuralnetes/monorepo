#!/bin/bash
function get_github_ref() {
  cd "${GITHUB_WORKSPACE}" && git branch --show-current
}

function get_github_sha() {
  cd "${GITHUB_WORKSPACE}" && git rev-parse HEAD
}

function get_github_sha_short() {
  cd "${GITHUB_WORKSPACE}" && git rev-parse --short HEAD
}

function setup_git() {
  cat <<EOF > "${HOME}/.gitconfig"
[user]
	name = ${GITHUB_USER_NAME}
	email = ${GITHUB_USER_EMAIL}
[core]
	editor = \$EDITOR
EOF
}