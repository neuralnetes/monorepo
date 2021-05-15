#!/bin/bash
cd "${GITHUB_WORKSPACE}/kustomize/manifests/flux-system/base"
wget "https://github.com/fluxcd/flux2/releases/download/${FLUX2_VERSION}/manifests.tar.gz"
tar xvfz manifests.tar.gz
rm -rf manifests.tar.gz
git add .
git commit -m "flux2 manifests ${KUBEFLOW_VERSION}"
git push
