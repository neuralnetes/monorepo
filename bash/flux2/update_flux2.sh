#!/bin/bash
cd "${GITHUB_WORKSPACE}/kustomize/flux-system/base"
wget "https://github.com/fluxcd/flux2/releases/download/${FLUX2_VERSION}/manifests.tar.gz"
tar xvfz manifests.tar.gz
git commit -am "update flux2 to version ${FLUX2_VERSION}"
