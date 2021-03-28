#!/bin/bash
git clone https://github.com/tfutils/tfenv.git "${GITHUB_WORKSPACE}"/.tfenv
ln -s "${GITHUB_WORKSPACE}"/.tfenv/bin/* "${GITHUB_WORKSPACE_BIN}"
tfenv install
