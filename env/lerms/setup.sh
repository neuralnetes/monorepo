#!/bin/bash
GOPATH="${HOME}/go"
GITHUB_OWNER="neuralnetes"
GITHUB_REPOSITORY="${GITHUB_OWNER}/monorepo"
GITHUB_WORKSPACE="${GOPATH}/src/github.com/${GITHUB_REPOSITORY}"
GITHUB_USER="lerms"
GITHUB_USER_WORKSPACE="${GITHUB_WORKSPACE}/env/${GITHUB_USER}"
ln -fs "${GITHUB_USER_WORKSPACE}/.envrc-root" "${GITHUB_WORKSPACE}/.envrc"
ln -fs "${GITHUB_USER_WORKSPACE}/.gitconfig" "${HOME}/.gitconfig"
ln -fs "${GITHUB_USER_WORKSPACE}/.zshrc" "${HOME}/.zshrc"
