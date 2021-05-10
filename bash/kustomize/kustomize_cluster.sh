#!/bin/bash
PATHS=(
  "kustomize/manifests/external-secrets/overlays/${KUBEFLOW_PROJECT}"
  "kustomize/manifests/external-dns/overlays/${KUBEFLOW_PROJECT}"
  "kustomize/manifests/secrets/kubeflow/overlays/${KUBEFLOW_PROJECT}"
  "kustomize/manifests/secrets/istio-system/overlays/${KUBEFLOW_PROJECT}"
  "kustomize/manifests/kubeflow/1.3/overlays/${KUBEFLOW_PROJECT}/common/cert-manager/cert-manager/overlays/letsencrypt"
  "kustomize/manifests/kubeflow/1.3/overlays/${KUBEFLOW_PROJECT}/common/istio-1-9-0/istio-install/base"
  "kustomize/manifests/kubeflow/1.3/overlays/${KUBEFLOW_PROJECT}/common/oidc-authservice/base"
  "kustomize/manifests/kubeflow/1.3/overlays/${KUBEFLOW_PROJECT}/common/dex/overlays/istio"
  "kustomize/manifests/kubeflow/1.3/overlays/${KUBEFLOW_PROJECT}/common/knative/knative-serving-install/base"
  "kustomize/manifests/kubeflow/1.3/overlays/${KUBEFLOW_PROJECT}/common/istio-1-9-0/kubeflow-istio-resources/base"
  "kustomize/manifests/deploy/overlays/${KUBEFLOW_PROJECT}"
  "kustomize/manifests/flux-kustomization/external-secrets/overlays/${KUBEFLOW_PROJECT}"
  "kustomize/manifests/flux-kustomization/external-dns/overlays/${KUBEFLOW_PROJECT}"
  "kustomize/manifests/flux-kustomization/secrets/kubeflow/overlays/${KUBEFLOW_PROJECT}"
  "kustomize/manifests/flux-kustomization/secrets/istio-system/overlays/${KUBEFLOW_PROJECT}"
  "kustomize/manifests/flux-kustomization/kubeflow/1.3/overlays/${KUBEFLOW_PROJECT}"
  "kustomize/manifests/flux-kustomization/cluster/overlays/${KUBEFLOW_PROJECT}"
  "kustomize/manifests/flux-kustomization/deploy/overlays/${KUBEFLOW_PROJECT}"
)

for path in "${PATHS[@]}"; do
  mkdir -p "${path}"
done

# secrets

cat <<EOF > "kustomize/manifests/secrets/istio-system/overlays/${KUBEFLOW_PROJECT}/patch-certificate.yaml"
apiVersion: cert-manager.io/v1alpha2
kind: Certificate
metadata:
  name: istio-certs
spec:
  dnsNames:
  - '*.${KUBEFLOW_PROJECT}.${NETWORK_PROJECT}.com'
EOF

cat <<EOF > "kustomize/manifests/secrets/istio-system/overlays/${KUBEFLOW_PROJECT}/kustomization.yaml"
namespace: istio-system
resources:
- ../../base
patchesStrategicMerge:
- patch-certificate.yaml

EOF

# external-secrets
cat <<EOF > "kustomize/manifests/external-secrets/overlays/${KUBEFLOW_PROJECT}/patch-service-account.yaml"
apiVersion: v1
kind: ServiceAccount
metadata:
  name: external-secrets
  annotations:
    iam.gke.io/gcp-service-account: external-secrets@${IAM_PROJECT}.iam.gserviceaccount.com

EOF

cat <<EOF > "kustomize/manifests/external-secrets/overlays/${KUBEFLOW_PROJECT}/kustomization.yaml"
resources:
- ../../base
patchesStrategicMerge:
- patch-service-account.yaml

EOF

# external-dns
cat <<EOF > "kustomize/manifests/external-dns/overlays/${KUBEFLOW_PROJECT}/patch-deployment.yaml"
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
        - --txt-owner-id=${KUBEFLOW_PROJECT}

EOF

cat <<EOF > "kustomize/manifests/external-dns/overlays/${KUBEFLOW_PROJECT}/patch-service-account.yaml"
apiVersion: v1
kind: ServiceAccount
metadata:
  name: external-dns
  annotations:
    iam.gke.io/gcp-service-account: external-dns@${IAM_PROJECT}.iam.gserviceaccount.com

EOF

cat <<EOF > "kustomize/manifests/external-dns/overlays/${KUBEFLOW_PROJECT}/kustomization.yaml"
resources:
- ../../base
patchesStrategicMerge:
- patch-deployment.yaml
- patch-service-account.yaml

EOF


./bash/kustomize/kubeflow/generate_istio_overlays.sh
./bash/kustomize/kubeflow/generate_oidc_authservice_overlays.sh
./bash/kustomize/kubeflow/generate_dex_overlays.sh

# knative-serving-install
cat <<EOF > "kustomize/manifests/kubeflow/1.3/overlays/${KUBEFLOW_PROJECT}/common/knative/knative-serving-install/base/patch-config.yaml"
apiVersion: v1
kind: ConfigMap
metadata:
  name: config-domain
  namespace: knative-serving
data:
  ${KUBEFLOW_PROJECT}.${NETWORK_PROJECT}.com: ""

EOF

cat <<EOF > "kustomize/manifests/kubeflow/1.3/overlays/${KUBEFLOW_PROJECT}/common/knative/knative-serving-install/base/kustomization.yaml"
resources:
- ../../../kubeflow/1.3/common/knative/knative-serving-install/base
patchesStrategicMerge:
- patch-config.yaml

EOF

# kubeflow-istio-resources
cat <<EOF > "kustomize/manifests/kubeflow/1.3/overlays/${KUBEFLOW_PROJECT}/common/istio-1-9-0/kubeflow-istio-resources/base/patch-gateway.yaml"
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
    - '*.${KUBEFLOW_PROJECT}.${NETWORK_PROJECT}.com'
EOF

cat <<EOF > "kustomize/manifests/kubeflow/1.3/overlays/${KUBEFLOW_PROJECT}/common/istio-1-9-0/kubeflow-istio-resources/base/kustomization.yaml"
resources:
- ../../../../../../../../kubeflow/1.3/base/common/istio-1-9-0/kubeflow-istio-resources/base
patchesStrategicMerge:
- patch-gateway.yaml

EOF

# deploy
cat <<EOF > "kustomize/manifests/deploy/overlays/${KUBEFLOW_PROJECT}/kustomization.yaml"
namespace: flux-system
resources:
- ../../base
- ../../../flux-kustomization/cluster/overlays/${KUBEFLOW_PROJECT}

EOF

# flux-kustomization
cat <<EOF > "kustomize/manifests/flux-kustomization/external-secrets/overlays/${KUBEFLOW_PROJECT}/patch-flux-kustomization.yaml"
apiVersion: kustomize.toolkit.fluxcd.io/v1beta1
kind: Kustomization
metadata:
  name: external-secrets
spec:
  path: kustomize/manifests/external-secrets/overlays/${KUBEFLOW_PROJECT}

EOF

cat <<EOF > "kustomize/manifests/flux-kustomization/external-secrets/overlays/${KUBEFLOW_PROJECT}/kustomization.yaml"
resources:
- ../../base
patchesStrategicMerge:
- patch-flux-kustomization.yaml

EOF

cat <<EOF > "kustomize/manifests/flux-kustomization/external-dns/overlays/${KUBEFLOW_PROJECT}/patch-flux-kustomization.yaml"
apiVersion: kustomize.toolkit.fluxcd.io/v1beta1
kind: Kustomization
metadata:
  name: external-dns
spec:
  path: kustomize/manifests/external-dns/overlays/${KUBEFLOW_PROJECT}

EOF

cat <<EOF > "kustomize/manifests/flux-kustomization/external-dns/overlays/${KUBEFLOW_PROJECT}/kustomization.yaml"
resources:
- ../../base
patchesStrategicMerge:
- patch-flux-kustomization.yaml

EOF

cat <<EOF > "kustomize/manifests/flux-kustomization/secrets/kubeflow/overlays/${KUBEFLOW_PROJECT}/patch-flux-kustomization.yaml"
apiVersion: kustomize.toolkit.fluxcd.io/v1beta1
kind: Kustomization
metadata:
  name: kubeflow-secrets
spec:
  path: kustomize/manifests/secrets/kubeflow/overlays/${KUBEFLOW_PROJECT}

EOF

cat <<EOF > "kustomize/manifests/flux-kustomization/secrets/kubeflow/overlays/${KUBEFLOW_PROJECT}/kustomization.yaml"
resources:
- ../../base
patchesStrategicMerge:
- patch-flux-kustomization.yaml

EOF

cat <<EOF > "kustomize/manifests/flux-kustomization/secrets/istio-system/overlays/${KUBEFLOW_PROJECT}/patch-flux-kustomization.yaml"
apiVersion: kustomize.toolkit.fluxcd.io/v1beta1
kind: Kustomization
metadata:
  name: istio-system-secrets
spec:
  path: kustomize/manifests/secrets/istio-system/overlays/${KUBEFLOW_PROJECT}

EOF

cat <<EOF > "kustomize/manifests/flux-kustomization/secrets/istio-system/overlays/${KUBEFLOW_PROJECT}/kustomization.yaml"
resources:
- ../../base
patchesStrategicMerge:
- patch-flux-kustomization.yaml

EOF

cat <<EOF > "kustomize/manifests/flux-kustomization/kubeflow/1.3/overlays/${KUBEFLOW_PROJECT}/patch-flux-kustomization.yaml"
apiVersion: kustomize.toolkit.fluxcd.io/v1beta1
kind: Kustomization
metadata:
  name: cert-manager
spec:
  path: kustomize/manifests/kubeflow/1.3/overlays/${KUBEFLOW_PROJECT}/common/cert-manager/cert-manager/overlays/letsencrypt
---
apiVersion: kustomize.toolkit.fluxcd.io/v1beta1
kind: Kustomization
metadata:
  name: istio-install
spec:
  path: kustomize/manifests/kubeflow/1.3/overlays/${KUBEFLOW_PROJECT}/common/istio-1-9-0/istio-install/base
---
apiVersion: kustomize.toolkit.fluxcd.io/v1beta1
kind: Kustomization
metadata:
  name: oidc-authservice
spec:
  path: kustomize/manifests/kubeflow/1.3/overlays/${KUBEFLOW_PROJECT}/common/oidc-authservice/base
---
apiVersion: kustomize.toolkit.fluxcd.io/v1beta1
kind: Kustomization
metadata:
  name: dex
spec:
  path: kustomize/manifests/kubeflow/1.3/overlays/${KUBEFLOW_PROJECT}/common/dex/overlays/istio
---
apiVersion: kustomize.toolkit.fluxcd.io/v1beta1
kind: Kustomization
metadata:
  name: knative-serving-install
spec:
  path: kustomize/manifests/kubeflow/1.3/overlays/${KUBEFLOW_PROJECT}/common/knative/knative-serving-install/base
---
apiVersion: kustomize.toolkit.fluxcd.io/v1beta1
kind: Kustomization
metadata:
  name: kubeflow-istio-resources
spec:
  path: kustomize/manifests/kubeflow/1.3/overlays/${KUBEFLOW_PROJECT}/common/istio-1-9-0/kubeflow-istio-resources/base

EOF

cat <<EOF > "kustomize/manifests/flux-kustomization/kubeflow/1.3/overlays/${KUBEFLOW_PROJECT}/kustomization.yaml"
resources:
- ../../base
patchesStrategicMerge:
- patch-flux-kustomization.yaml

EOF

cat <<EOF > "kustomize/manifests/flux-kustomization/cluster/overlays/${KUBEFLOW_PROJECT}/patch-flux-kustomization.yaml"
apiVersion: kustomize.toolkit.fluxcd.io/v1beta1
kind: Kustomization
metadata:
  name: cluster
spec:
  path: kustomize/manifests/flux-kustomization/cluster/overlays/${KUBEFLOW_PROJECT}

EOF

cat <<EOF > "kustomize/manifests/flux-kustomization/cluster/overlays/${KUBEFLOW_PROJECT}/kustomization.yaml"
resources:
- ../../base
- ../../../external-secrets/overlays/${KUBEFLOW_PROJECT}
- ../../../external-dns/overlays/${KUBEFLOW_PROJECT}
- ../../../secrets/kubeflow/overlays/${KUBEFLOW_PROJECT}
- ../../../secrets/istio-system/overlays/${KUBEFLOW_PROJECT}
- ../../../kubeflow/1.3/overlays/${KUBEFLOW_PROJECT}
patchesStrategicMerge:
- patch-flux-kustomization.yaml

EOF
