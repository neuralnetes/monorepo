#!/bin/bash
git clone https://github.com/cunymatthieu/tgenv.git "${GITHUB_WORKSPACE}"/.tgenv
ln -s "${GITHUB_WORKSPACE}"/.tgenv/bin/* "${GITHUB_WORKSPACE_BIN}"
tgenv install
