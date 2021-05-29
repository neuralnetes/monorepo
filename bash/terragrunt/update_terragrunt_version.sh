#!/bin/bash
tgenv list-remote \
  | head -n 1 \
  > "${GITHUB_WORKSPACE}/.terragrunt-version"
