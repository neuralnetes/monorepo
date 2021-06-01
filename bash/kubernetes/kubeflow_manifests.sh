#!/bin/bash
cd "${GITHUB_WORKSPACE}/kustomize/manifests/kubeflow/1.3/base"
wget "https://github.com/kubeflow/manifests/archive/${KUBEFLOW_VERSION}.tar.gz"
#wget "https://github.com/kubeflow/manifests/releases/download/${KUBEFLOW_VERSION}/manifests.tar.gz"
tar xvfz "${KUBEFLOW_VERSION}.tar.gz"
rm -rf "${KUBEFLOW_VERSION}.tar.gz"
cp -rf "manifests-1.3.0"/* .
rm -rf "manifests-1.3.0"
git add .
git commit -m "kubeflow manifests ${KUBEFLOW_VERSION}"
git push
