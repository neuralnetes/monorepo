#!/bin/bash
cd "${GITHUB_WORKSPACE}/kustomize/manifests/kubeflow/1.3/base"
wget "https://github.com/kubeflow/manifests/releases/download/${KUBEFLOW_VERSION}/manifests.tar.gz"
tar xvfz manifests.tar.gz
rm -rf manifests.tar.gz
git add .
git commit -m "kubeflow manifests ${KUBEFLOW_VERSION}"
