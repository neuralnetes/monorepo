#!/bin/bash
export ISTIO_VERSION=1.10.2
export DOWNLOAD_DIR="istio-${ISTIO_VERSION}"
export OUTPUT_DIR=kustomize/manifests
curl -L https://istio.io/downloadIstio | sh -
helm template istio-operator "${DOWNLOAD_DIR}/manifests/charts/istio-operator" \
  --set operatorNamespace=istio-operator \
  --output-dir "${OUTPUT_DIR}"
mkdir -p "${OUTPUT_DIR}/istio-operator/base"
mv "${DOWNLOAD_DIR}/manifests/charts/istio-operator/crds/crd-operator.yaml" "${OUTPUT_DIR}/istio-operator/base"
mv "${OUTPUT_DIR}/istio-operator/templates"/* "${OUTPUT_DIR}/istio-operator/base"
rm -rf "${OUTPUT_DIR}/istio-operator/templates"

# istio-operator
cat <<EOF >"${OUTPUT_DIR}/istio-operator/base/kustomization.yaml"
resources:
- crd-operator.yaml
- clusterrole.yaml
- clusterrole_binding.yaml
- deployment.yaml
- namespace.yaml
- service.yaml
- service_account.yaml
EOF

# istio-system
mkdir -p "${OUTPUT_DIR}/istio-system/base"
cat <<EOF >"${OUTPUT_DIR}/istio-system/base/istio-operator.yaml"
apiVersion: install.istio.io/v1alpha1
kind: IstioOperator
metadata:
  name: default-istiocontrolplane
spec:
  profile: default
EOF

cat <<EOF >"${OUTPUT_DIR}/istio-system/base/kustomization.yaml"
namespace: istio-system
resources:
- istio-operator.yaml
EOF

rm -rf "${DOWNLOAD_DIR}"
