#!/bin/bash
tfenv list-remote \
  | head -n 1 \
  > "${GITHUB_WORKSPACE}/.terraform-version"
