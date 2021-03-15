#!/bin/bash
git clone https://github.com/tfutils/tfenv.git "${HOME}"
ln -s "${HOME}"/bin/* "${HOME_BIN}"
tfenv install
