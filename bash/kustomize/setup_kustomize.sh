#!/bin/bash
curl -s "https://raw.githubusercontent.com/kubernetes-sigs/kustomize/master/hack/install_kustomize.sh" \
  > "${GITHUB_WORKSPACE}/install_kustomize.sh"
bash "${GITHUB_WORKSPACE}/install_kustomize.sh" "${HOME}/.local/bin"
rm "${GITHUB_WORKSPACE}/install_kustomize.sh"
