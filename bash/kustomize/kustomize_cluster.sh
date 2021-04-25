#!/bin/bash
CLUSTER=$1
PATHS=(
  "kustomize/manifests/kubeflow/1.3/overlays/${CLUSTER}/common/cert-manager/cert-manager/overlays/self-signed"
  "kustomize/manifests/kubeflow/1.3/overlays/${CLUSTER}/common/istio-1-9-0/istio-install/base"
  "kustomize/manifests/kubeflow/1.3/overlays/${CLUSTER}/common/oidc-authservice/base"
  "kustomize/manifests/kubeflow/1.3/overlays/${CLUSTER}/common/dex/overlays/istio"
  "kustomize/manifests/kubeflow/1.3/overlays/${CLUSTER}/common/knative/knative-serving-install/base"
  "kustomize/manifests/kubeflow/1.3/overlays/${CLUSTER}/common/istio-1-9-0/kubeflow-istio-resources/base"
)
for path in "${PATHS[@]}"; do
  mkdir -p "${path}"
  touch "${path}/kustomization.yaml"
done
