#!/bin/bash

cat <<EOF > "kustomize/manifests/kubeflow/1.3/overlays/${KUBEFLOW_PROJECT}/common/cert-manager/cert-manager/overlays/letsencrypt/patch-cluster-issuer.yaml"
apiVersion: cert-manager.io/v1alpha2
kind: ClusterIssuer
metadata:
  name: letsencrypt-prod
spec:
  acme:
    email: bot+letsencrypt-prod@${GCP_WORKSPACE_DOMAIN_NAME}
    http01: null
    privateKeySecretRef: null
    server: https://acme-v02.api.letsencrypt.org/directory
    solvers:
      - dns01:
          clouddns:
            project: ${NETWORK_PROJECT}

EOF

cat <<EOF > "kustomize/manifests/kubeflow/1.3/overlays/${KUBEFLOW_PROJECT}/common/cert-manager/cert-manager/overlays/letsencrypt/cluster-issuer.yaml"
apiVersion: cert-manager.io/v1alpha2
kind: ClusterIssuer
metadata:
  name: letsencrypt-staging
spec:
  acme:
    email: bot+letsencrypt-staging@${GCP_WORKSPACE_DOMAIN_NAME}
    server: https://acme-staging-v02.api.letsencrypt.org/directory
    solvers:
      - dns01:
          clouddns:
            project: ${NETWORK_PROJECT}

EOF

cat <<EOF > "kustomize/manifests/kubeflow/1.3/overlays/${KUBEFLOW_PROJECT}/common/cert-manager/cert-manager/overlays/letsencrypt/kustomization.yaml"
namespace: cert-manager
resources:
- ../../../../../../../../../kubeflow/1.3/base/common/cert-manager/cert-manager/overlays/letsencrypt
- cluster-issuer.yaml
patchesStrategicMerge:
- patch-cluster-issuer.yaml

EOF