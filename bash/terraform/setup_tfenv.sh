#!/bin/bash
git clone https://github.com/tfutils/tfenv.git "${HOME}"/.tfenv
ln -s "${HOME}"/.tfenv/bin/* "${HOME_BIN}"
tfenv install
