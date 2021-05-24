#!/bin/bash
git clone https://github.com/cunymatthieu/tgenv.git "${HOME}/.tgenv"
ln -fs "${HOME}/.tgenv/bin"/* "${HOME}/.local/bin"
tgenv install
