#!/bin/bash
git clone https://github.com/cunymatthieu/tgenv.git "${GITHUB_USER_WORKSPACE}"/.tgenv
ln -s "${GITHUB_USER_WORKSPACE}"/.tgenv/bin/* "${GITHUB_USER_WORKSPACE_BIN}"
tgenv install
