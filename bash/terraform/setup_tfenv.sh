#!/bin/bash
git clone https://github.com/tfutils/tfenv.git "${GITHUB_USER_WORKSPACE}"/.tfenv
ln -s "${GITHUB_USER_WORKSPACE}"/.tfenv/bin/* "${GITHUB_USER_WORKSPACE_BIN}"
tfenv install
