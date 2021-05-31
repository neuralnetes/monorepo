#!/bin/bash
rm -rf "${HOME}/.pyenv"
git clone https://github.com/pyenv/pyenv.git "${HOME}/.pyenv"
ln -fs "${HOME}/.pyenv/bin"/* "${HOME}/.local/bin"
pyenv install
