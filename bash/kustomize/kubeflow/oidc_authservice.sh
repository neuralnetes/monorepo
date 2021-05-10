#!/bin/bash
cat <<EOF > "kustomize/manifests/kubeflow/1.3/overlays/${KUBEFLOW_PROJECT}/common/oidc-authservice/base/patch-config.yaml"
kind: ConfigMap
metadata:
  labels:
    testing: cool beans
EOF

cat <<EOF > "kustomize/manifests/kubeflow/1.3/overlays/${KUBEFLOW_PROJECT}/common/oidc-authservice/base/kustomization.yaml"
resources:
- ../../../../../../../kubeflow/1.3/base/common/oidc-authservice/base
patchesStategicMerge:
- patch-config.yaml
EOF
