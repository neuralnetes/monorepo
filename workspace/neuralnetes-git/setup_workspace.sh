#!/bin/bash
export OS="linux"
export ARCH="amd64"
export PATH="${HOME}/.local/bin:${PATH}"
export EDITOR="vim"
export GITHUB_NAME="neuralnetes-git"
export GITHUB_EMAIL="bot+git@neuralnetes.com"
source "${GITHUB_WORKSPACE}/bash/github/functions.sh"
setup_workspace
