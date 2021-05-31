#!/bin/bash
curl -s https://fluxcd.io/install.sh \
  > install.sh
bash install.sh "${HOME}/.local/bin"
