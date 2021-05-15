#!/bin/bash
cd "${GITHUB_WORKSPACE}/kustomize/manifests/kubeflow/1.3/base"
wget "https://github.com/kubeflow/manifests/archive/${KUBEFLOW_VERSION}.tar.gz"
#wget "https://github.com/kubeflow/manifests/releases/download/${KUBEFLOW_VERSION}/manifests.tar.gz"
tar xvfz v1.3.0.tar.gz
rm -rf v1.3.0.tar.gz
git add .
git commit -m "kubeflow manifests ${KUBEFLOW_VERSION}"
