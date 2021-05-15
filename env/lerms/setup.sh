#!/bin/bash
GITHUB_OWNER="neuralnetes"
GITHUB_REPOSITORY="${GITHUB_OWNER}/monorepo"
GITHUB_WORKSPACE="${GOPATH}/src/github.com/${GITHUB_REPOSITORY}"
GITHUB_USER="lerms"
GITHUB_USER_WORKSPACE="${GITHUB_WORKSPACE}/env/${GITHUB_USER}"
SYMBOLIC_LINK_FILES=(
  ".envrc"
  ".envrc-alias"
  ".envrc-base"
  ".envrc-function"
  ".envrc-github"
  ".envrc-secret"
  ".gitconfig"
  ".zshrc"
)
for file in "${SYMBOLIC_LINK_FILES[@]}"; do
  ln -fs "${GITHUB_USER_WORKSPACE}/${file}" "${HOME}/${file}"
done

ln -fs "${GITHUB_WORKSPACE}/.gitignore" "${HOME}/.gitignore"
