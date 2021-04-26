#!/bin/bash
PATHS=(
  "kustomize/manifests/external-secrets/overlays/${COMPUTE_PROJECT}"
  "kustomize/manifests/external-dns/overlays/${COMPUTE_PROJECT}"
  "kustomize/manifests/secrets/kubeflow/overlays/${COMPUTE_PROJECT}"
  "kustomize/manifests/external-secrets/overlays/${COMPUTE_PROJECT}"
  "kustomize/manifests/kubeflow/1.3/overlays/${COMPUTE_PROJECT}/common/cert-manager/cert-manager/overlays/letsencrypt"
  "kustomize/manifests/kubeflow/1.3/overlays/${COMPUTE_PROJECT}/common/istio-1-9-0/istio-install/base"
  "kustomize/manifests/kubeflow/1.3/overlays/${COMPUTE_PROJECT}/common/oidc-authservice/base"
  "kustomize/manifests/kubeflow/1.3/overlays/${COMPUTE_PROJECT}/common/dex/overlays/istio"
  "kustomize/manifests/kubeflow/1.3/overlays/${COMPUTE_PROJECT}/common/knative/knative-serving-install/base"
  "kustomize/manifests/kubeflow/1.3/overlays/${COMPUTE_PROJECT}/common/istio-1-9-0/kubeflow-istio-resources/base"
  "kustomize/manifests/deploy/overlays/${COMPUTE_PROJECT}"
  "kustomize/manifests/flux-kustomization/external-secrets/overlays/${COMPUTE_PROJECT}"
  "kustomize/manifests/flux-kustomization/external-dns/overlays/${COMPUTE_PROJECT}"
  "kustomize/manifests/flux-kustomization/secrets/kubeflow/overlays/${COMPUTE_PROJECT}"
  "kustomize/manifests/flux-kustomization/kubeflow/1.3/overlays/${COMPUTE_PROJECT}"
  "kustomize/manifests/flux-kustomization/cluster/overlays/${COMPUTE_PROJECT}"
  "kustomize/manifests/flux-kustomization/deploy/overlays/${COMPUTE_PROJECT}"
)

for path in "${PATHS[@]}"; do
  mkdir -p "${path}"
done

# external-secrets
cat <<EOF > "kustomize/manifests/external-secrets/overlays/${COMPUTE_PROJECT}/patch-service-account.yaml"
apiVersion: v1
kind: ServiceAccount
metadata:
  name: external-secrets
  annotations:
    iam.gke.io/gcp-service-account: external-secrets@${IAM_PROJECT}.iam.gserviceaccount.com

EOF

cat <<EOF > "kustomize/manifests/external-secrets/overlays/${COMPUTE_PROJECT}/kustomization.yaml"
resources:
- ../../base
patchesStrategicMerge:
- patch-service-account.yaml

EOF

# external-dns
cat <<EOF > "kustomize/manifests/external-dns/overlays/${COMPUTE_PROJECT}/patch-deployment.yaml"
apiVersion: apps/v1
kind: Deployment
metadata:
  name: external-dns
spec:
  template:
    spec:
      containers:
      - name: external-dns
        image: registry.opensource.zalan.do/teapot/external-dns:latest
        args:
        - --source=service
        - --provider=google
        - --google-project=${NETWORK_PROJECT}
        - --registry=txt
        - --txt-owner-id=external-dns-${COMPUTE_PROJECT}

EOF

cat <<EOF > "kustomize/manifests/external-dns/overlays/${COMPUTE_PROJECT}/patch-service-account.yaml"
apiVersion: v1
kind: ServiceAccount
metadata:
  name: external-dns
  annotations:
    iam.gke.io/gcp-service-account: external-dns@${IAM_PROJECT}.iam.gserviceaccount.com

EOF

cat <<EOF > "kustomize/manifests/external-dns/overlays/${COMPUTE_PROJECT}/kustomization.yaml"
resources:
- ../../base
patchesStrategicMerge:
- patch-deployment.yaml
- patch-service-account.yaml

EOF

# cert-manager
cat <<EOF > "kustomize/manifests/kubeflow/1.3/overlays/${COMPUTE_PROJECT}/common/cert-manager/cert-manager/overlays/letsencrypt/patch-cluster-issuer.yaml"
apiVersion: cert-manager.io/v1alpha2
kind: ClusterIssuer
metadata:
  name: letsencrypt-prod
spec:
  acme:
    email: bot+letsencrypt-prod@neuralnetes.com
    server: https://acme-v02.api.letsencrypt.org/directory
    solvers:
      - dns01:
          cloudDNS:
            project: ${NETWORK_PROJECT}

EOF

cat <<EOF > "kustomize/manifests/kubeflow/1.3/overlays/${COMPUTE_PROJECT}/common/cert-manager/cert-manager/overlays/letsencrypt/cluster-issuer.yaml"
apiVersion: cert-manager.io/v1alpha2
kind: ClusterIssuer
metadata:
  name: letsencrypt-staging
spec:
  acme:
    email: bot+letsencrypt-staging@neuralnetes.com
    server: https://acme-staging-v02.api.letsencrypt.org/directory
    solvers:
      - dns01:
          cloudDNS:
            project: ${NETWORK_PROJECT}

EOF

cat <<EOF > "kustomize/manifests/kubeflow/1.3/overlays/${COMPUTE_PROJECT}/common/cert-manager/cert-manager/overlays/letsencrypt/kustomization.yaml"
resources:
- ../../../../../../../../../kubeflow/1.3/base/common/cert-manager/cert-manager/overlays/letsencrypt
- cluster-issuer.yaml
patchesStrategicMerge:
- patch-cluster-issuer.yaml

EOF

# istio-install
cat <<EOF > "kustomize/manifests/kubeflow/1.3/overlays/${COMPUTE_PROJECT}/common/istio-1-9-0/istio-install/base/patch-service.yaml"
kind: Service

EOF

cat <<EOF > "kustomize/manifests/kubeflow/1.3/overlays/${COMPUTE_PROJECT}/common/istio-1-9-0/istio-install/base/kustomization.yaml"
resources:
- ../../../kubeflow/1.3/base/common/istio-1-9-0/istio-install/base
patchesStrategicMerge:
- patch-service.yaml

EOF

# oidc-authservice
cat <<EOF > "kustomize/manifests/kubeflow/1.3/overlays/${COMPUTE_PROJECT}/common/oidc-authservice/base/patch-config.yaml"
kind: ConfigMap

EOF

cat <<EOF > "kustomize/manifests/kubeflow/1.3/overlays/${COMPUTE_PROJECT}/common/oidc-authservice/base/kustomization.yaml"
resources:
- ../../../kubeflow/1.3/base/common/oidc-authservice/base
patchesStrategicMerge:
- patch-config.yaml

EOF

# dex
cat <<EOF > "kustomize/manifests/kubeflow/1.3/overlays/${COMPUTE_PROJECT}/common/dex/overlays/istio/patch-config.yaml"
kind: ConfigMap

EOF

cat <<EOF > "kustomize/manifests/kubeflow/1.3/overlays/${COMPUTE_PROJECT}/common/dex/overlays/istio/kustomization.yaml"
resources:
- ../../../kubeflow/1.3/base/common/dex/overlays/istio
patchesStrategicMerge:
- patch-config.yaml

EOF

# knative-serving-install
cat <<EOF > "kustomize/manifests/kubeflow/1.3/overlays/${COMPUTE_PROJECT}/common/knative/knative-serving-install/base/patch-config.yaml"
kind: ConfigMap

EOF

cat <<EOF > "kustomize/manifests/kubeflow/1.3/overlays/${COMPUTE_PROJECT}/common/knative/knative-serving-install/base/kustomization.yaml"
resources:
- ../../../kubeflow/1.3/common/knative/knative-serving-install/base
patchesStrategicMerge:
- patch-config.yaml

EOF

# kubeflow-istio-resources
cat <<EOF > "kustomize/manifests/kubeflow/1.3/overlays/${COMPUTE_PROJECT}/common/istio-1-9-0/kubeflow-istio-resources/base/patch-gateway.yaml"
kind: Gateway

EOF

cat <<EOF > "kustomize/manifests/kubeflow/1.3/overlays/${COMPUTE_PROJECT}/common/istio-1-9-0/kubeflow-istio-resources/base/kustomization.yaml"
resources:
- ../../../kubeflow/1.3/common/istio-1-9-0/kubeflow-istio-resources/base
patchesStrategicMerge:
- patch-gateway.yaml

EOF

# deploy
cat <<EOF > "kustomize/manifests/deploy/overlays/${COMPUTE_PROJECT}/kustomization.yaml"
namespace: flux-system
resources:
- ../../base
- ../../../flux-kustomization/cluster/overlays/${COMPUTE_PROJECT}

EOF

# flux-kustomization
cat <<EOF > "kustomize/manifests/flux-kustomization/external-secrets/overlays/${COMPUTE_PROJECT}/patch-flux-kustomization.yaml"
apiVersion: kustomize.toolkit.fluxcd.io/v1beta1
kind: Kustomization
metadata:
  name: external-secrets
spec:
  path: kustomize/manifests/external-secrets/overlays/${COMPUTE_PROJECT}

EOF

cat <<EOF > "kustomize/manifests/flux-kustomization/external-secrets/overlays/${COMPUTE_PROJECT}/kustomization.yaml"
resources:
- ../../base
patchesStrategicMerge:
- patch-flux-kustomization.yaml

EOF

cat <<EOF > "kustomize/manifests/flux-kustomization/external-dns/overlays/${COMPUTE_PROJECT}/patch-flux-kustomization.yaml"
apiVersion: kustomize.toolkit.fluxcd.io/v1beta1
kind: Kustomization
metadata:
  name: external-dns
spec:
  path: kustomize/manifests/external-dns/overlays/${COMPUTE_PROJECT}

EOF

cat <<EOF > "kustomize/manifests/flux-kustomization/secrets/kubeflow/overlays/${COMPUTE_PROJECT}/kustomization.yaml"
resources:
- ../../base
patchesStrategicMerge:
- patch-flux-kustomization.yaml

EOF

cat <<EOF > "kustomize/manifests/flux-kustomization/secrets/kubeflow/overlays/${COMPUTE_PROJECT}/patch-flux-kustomization.yaml"
apiVersion: kustomize.toolkit.fluxcd.io/v1beta1
kind: Kustomization
metadata:
  name: kubeflow-secrets
spec:
  path: kustomize/manifests/secrets/kubeflow/overlays/${COMPUTE_PROJECT}

EOF

cat <<EOF > "kustomize/manifests/flux-kustomization/secrets/kubeflow/overlays/${COMPUTE_PROJECT}/kustomization.yaml"
resources:
- ../../base
patchesStrategicMerge:
- patch-flux-kustomization.yaml

EOF

cat <<EOF > "kustomize/manifests/flux-kustomization/kubeflow/1.3/overlays/${COMPUTE_PROJECT}/patch-flux-kustomization.yaml"
apiVersion: kustomize.toolkit.fluxcd.io/v1beta1
kind: Kustomization
metadata:
  name: cert-manager
spec:
  path: kustomize/manifests/kubeflow/1.3/overlays/${COMPUTE_PROJECT}/common/cert-manager/cert-manager/overlays/letsencrypt
---
apiVersion: kustomize.toolkit.fluxcd.io/v1beta1
kind: Kustomization
metadata:
  name: istio-install
spec:
  path: kustomize/manifests/kubeflow/1.3/overlays/${COMPUTE_PROJECT}/common/istio-1-9-0/istio-install/base
---
apiVersion: kustomize.toolkit.fluxcd.io/v1beta1
kind: Kustomization
metadata:
  name: oidc-authservice
spec:
  path: kustomize/manifests/kubeflow/1.3/overlays/${COMPUTE_PROJECT}/common/oidc-authservice/base
---
apiVersion: kustomize.toolkit.fluxcd.io/v1beta1
kind: Kustomization
metadata:
  name: dex
spec:
  path: kustomize/manifests/kubeflow/1.3/overlays/${COMPUTE_PROJECT}/common/dex/overlays/istio
---
apiVersion: kustomize.toolkit.fluxcd.io/v1beta1
kind: Kustomization
metadata:
  name: knative-serving-install
spec:
  path: kustomize/manifests/kubeflow/1.3/overlays/${COMPUTE_PROJECT}/common/knative/knative-serving-install/base
---
apiVersion: kustomize.toolkit.fluxcd.io/v1beta1
kind: Kustomization
metadata:
  name: kubeflow-istio-resources
spec:
  path: kustomize/manifests/kubeflow/1.3/overlays/${COMPUTE_PROJECT}/common/istio-1-9-0/kubeflow-istio-resources/base

EOF

cat <<EOF > "kustomize/manifests/flux-kustomization/kubeflow/1.3/overlays/${COMPUTE_PROJECT}/kustomization.yaml"
resources:
- ../../base
patchesStrategicMerge:
- patch-flux-kustomization.yaml

EOF

cat <<EOF > "kustomize/manifests/flux-kustomization/cluster/overlays/${COMPUTE_PROJECT}/patch-flux-kustomization.yaml"
apiVersion: kustomize.toolkit.fluxcd.io/v1beta1
kind: Kustomization
metadata:
  name: cluster
spec:
  path: kustomize/manifests/flux-kustomization/cluster/overlays/${COMPUTE_PROJECT}

EOF

cat <<EOF > "kustomize/manifests/flux-kustomization/cluster/overlays/${COMPUTE_PROJECT}/kustomization.yaml"
resources:
- ../../base
patchesStrategicMerge:
- patch-flux-kustomization.yaml

EOF

cat <<EOF > "kustomize/manifests/flux-kustomization/deploy/overlays/${COMPUTE_PROJECT}/patch-flux-kustomization.yaml"
apiVersion: kustomize.toolkit.fluxcd.io/v1beta1
kind: Kustomization
metadata:
  name: deploy
spec:
  path: kustomize/manifests/deploy/overlays/${COMPUTE_PROJECT}
EOF

cat <<EOF > "kustomize/manifests/flux-kustomization/deploy/overlays/${COMPUTE_PROJECT}/kustomization.yaml"
resources:
- ../../base
patchesStrategicMerge:
- patch-flux-kustomization.yaml

EOF
