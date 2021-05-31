#!/bin/bash
rm -rf "${HOME}/.tfenv"
git clone https://github.com/tfutils/tfenv.git "${HOME}/.tfenv"
ln -fs "${HOME}/.tfenv/bin"/* "${HOME}/.local/bin"
tfenv install
