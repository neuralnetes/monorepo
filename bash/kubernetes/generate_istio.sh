#!/bin/bash
export ISTIO_VERSION=1.10.2
curl -L https://istio.io/downloadIstio | sh -
helm template istio-operator "istio-${ISTIO_VERSION}/manifests/charts/istio-operator" \
  --set operatorNamespace=istio-operator --output-dir kustomize/manifests
rm -rf istio-${ISTIO_VERSION}
mkdir -p kustomize/manifests/istio-operator/base
mv kustomize/manifests/istio-operator/templates/* kustomize/manifests/istio-operator/base
rm -rf kustomize/manifests/istio-operator/templates
# istio-operator
cat <<EOF >"kustomize/manifests/istio-operator/base/kustomization.yaml"
resources:
- clusterrole.yaml
- clusterrole_binding.yaml
- deployment.yaml
- namespace.yaml
- service.yaml
- service_account.yaml
EOF
# istio-system
mkdir -p kustomize/manifests/istio-system/base
cat <<EOF >"kustomize/manifests/istio-system/base/istio-operator.yaml"
apiVersion: install.istio.io/v1alpha1
kind: IstioOperator
metadata:
  name: default-istiocontrolplane
spec:
  profile: default
EOF
cat <<EOF >"kustomize/manifests/istio-system/base/kustomization.yaml"
namespace: istio-system
resources:
- istio-operator.yaml
EOF
