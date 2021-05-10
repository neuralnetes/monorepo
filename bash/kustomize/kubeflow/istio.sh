#!/bin/bash

cat <<EOF > "kustomize/manifests/kubeflow/1.3/overlays/${KUBEFLOW_PROJECT}/common/istio-1-9-0/istio-install/base/patch-service.yaml"
apiVersion: v1
kind: Service
metadata:
  name: istio-ingressgateway
  namespace: istio-system
  annotations:
    external-dns.alpha.kubernetes.io/hostname: '*.${KUBEFLOW_PROJECT}.${NETWORK_PROJECT}.${GCP_WORKSPACE_DOMAIN_NAME}.'
    networking3.gke.io/load-balancer-type: Internal
spec:
  type: LoadBalancer

EOF

cat <<EOF > "kustomize/manifests/kubeflow/1.3/overlays/${KUBEFLOW_PROJECT}/common/istio-1-9-0/istio-install/base/patch-gateway.yaml"
#apiVersion: networking.istio.io/v1alpha3
#kind: Gateway
#metadata:
#  name: istio-ingressgateway
#spec:
#  servers:
#  - port:
#      number: 443
#      name: https
#      protocol: HTTPS
#    tls:
#      mode: SIMPLE
#      credentialName: istio-certs
#    hosts:
#    - '*.${KUBEFLOW_PROJECT}.${NETWORK_PROJECT}.${GCP_WORKSPACE_DOMAIN_NAME}'
---
apiVersion: networking.istio.io/v1alpha3
kind: Gateway
metadata:
  name: kubeflow-gateway
spec:
  servers:
  - port:
      number: 443
      name: https
      protocol: HTTPS
    tls:
      mode: SIMPLE
      credentialName: istio-certs
    hosts:
    - '*.${KUBEFLOW_PROJECT}.${NETWORK_PROJECT}.${GCP_WORKSPACE_DOMAIN_NAME}'
EOF

cat <<EOF > "kustomize/manifests/kubeflow/1.3/overlays/${KUBEFLOW_PROJECT}/common/istio-1-9-0/istio-install/base/kustomization.yaml"
resources:
- ../../../../../../../../kubeflow/1.3/base/common/istio-1-9-0/istio-install/base
patchesStrategicMerge:
- patch-gateway.yaml
- patch-service.yaml

EOF
