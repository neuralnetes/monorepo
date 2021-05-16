#!/bin/bash
PATHS=(
  "kustomize/manifests/external-secrets/overlays/${KUBEFLOW_PROJECT}"
  "kustomize/manifests/external-dns/overlays/${KUBEFLOW_PROJECT}"
  "kustomize/manifests/kubeflow/overlays/${KUBEFLOW_PROJECT}/common/istio-1-9-0/istio-install/base"
  "kustomize/manifests/kubeflow/overlays/${KUBEFLOW_PROJECT}/common/knative/knative-serving-install/base"
  "kustomize/manifests/kubeflow/overlays/${KUBEFLOW_PROJECT}/common/istio-1-9-0/kubeflow-istio-resources/base"
  "kustomize/manifests/deploy/overlays/${KUBEFLOW_PROJECT}"
  "kustomize/manifests/flux-kustomization/external-secrets/overlays/${KUBEFLOW_PROJECT}"
  "kustomize/manifests/flux-kustomization/external-dns/overlays/${KUBEFLOW_PROJECT}"
  "kustomize/manifests/flux-kustomization/kubeflow/overlays/${KUBEFLOW_PROJECT}"
  "kustomize/manifests/flux-kustomization/cluster/overlays/${KUBEFLOW_PROJECT}"
  "kustomize/manifests/flux-kustomization/deploy/overlays/${KUBEFLOW_PROJECT}"
)

for path in "${PATHS[@]}"; do
  rm -rf "${path}"
  mkdir -p "${path}"
done

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
namespace: external-secrets
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
namespace: external-dns
resources:
- ../../base
patchesStrategicMerge:
- patch-deployment.yaml
- patch-service-account.yaml
EOF

# istio-install
cat <<EOF > "kustomize/manifests/kubeflow/overlays/${KUBEFLOW_PROJECT}/common/istio-1-9-0/istio-install/base/patch-service.yaml"
apiVersion: v1
kind: Service
metadata:
  name: istio-ingressgateway
  namespace: istio-system
  annotations:
    external-dns.alpha.kubernetes.io/hostname: 'kubeflow.${KUBEFLOW_PROJECT}.${NETWORK_PROJECT}.${GCP_WORKSPACE_DOMAIN_NAME}.'
spec:
  type: LoadBalancer
EOF

cat <<EOF > "kustomize/manifests/kubeflow/overlays/${KUBEFLOW_PROJECT}/common/istio-1-9-0/istio-install/base/patch-gateway.yaml"
apiVersion: networking.istio.io/v1alpha3
kind: Gateway
metadata:
  name: istio-ingressgateway
spec:
  servers:
  - port:
      number: 80
      name: http
      protocol: HTTP
    hosts:
    - '*'
EOF

cat <<EOF > "kustomize/manifests/kubeflow/overlays/${KUBEFLOW_PROJECT}/common/istio-1-9-0/istio-install/base/kustomization.yaml"
namespace: istio-system
resources:
- ../../../../../../../../kubeflow/base/common/istio-1-9-0/istio-install/base
patchesStrategicMerge:
- patch-gateway.yaml
- patch-service.yaml
EOF

# knative-serving-install
cat <<EOF > "kustomize/manifests/kubeflow/overlays/${KUBEFLOW_PROJECT}/common/knative/knative-serving-install/base/patch-config.yaml"
apiVersion: v1
kind: ConfigMap
metadata:
  name: config-domain
  namespace: knative-serving
data:
  kubeflow.${KUBEFLOW_PROJECT}.${NETWORK_PROJECT}.${GCP_WORKSPACE_DOMAIN_NAME}: ""
EOF

cat <<EOF > "kustomize/manifests/kubeflow/overlays/${KUBEFLOW_PROJECT}/common/knative/knative-serving-install/base/kustomization.yaml"
namespace: knative-serving
resources:
- ../../../../../../../../kubeflow/base/common/knative/knative-serving-install/base
patchesStrategicMerge:
- patch-config.yaml
EOF

# kubeflow-istio-resources
cat <<EOF > "kustomize/manifests/kubeflow/overlays/${KUBEFLOW_PROJECT}/common/istio-1-9-0/kubeflow-istio-resources/base/patch-gateway.yaml"
apiVersion: networking.istio.io/v1alpha3
kind: Gateway
metadata:
  name: kubeflow-gateway
spec:
  servers:
  - port:
      number: 80
      name: http
      protocol: HTTP
    hosts:
    - '*'
EOF

cat <<EOF > "kustomize/manifests/kubeflow/overlays/${KUBEFLOW_PROJECT}/common/istio-1-9-0/kubeflow-istio-resources/base/kustomization.yaml"
namespace: kubeflow
resources:
- ../../../../../../../../kubeflow/base/common/istio-1-9-0/kubeflow-istio-resources/base
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

cat <<EOF > "kustomize/manifests/flux-kustomization/kubeflow/overlays/${KUBEFLOW_PROJECT}/patch-flux-kustomization.yaml"
---
apiVersion: kustomize.toolkit.fluxcd.io/v1beta1
kind: Kustomization
metadata:
  name: istio-install
spec:
  path: kustomize/manifests/kubeflow/overlays/${KUBEFLOW_PROJECT}/common/istio-1-9-0/istio-install/base
---
apiVersion: kustomize.toolkit.fluxcd.io/v1beta1
kind: Kustomization
metadata:
  name: knative-serving-install
spec:
  path: kustomize/manifests/kubeflow/overlays/${KUBEFLOW_PROJECT}/common/knative/knative-serving-install/base
---
apiVersion: kustomize.toolkit.fluxcd.io/v1beta1
kind: Kustomization
metadata:
  name: kubeflow-istio-resources
spec:
  path: kustomize/manifests/kubeflow/overlays/${KUBEFLOW_PROJECT}/common/istio-1-9-0/kubeflow-istio-resources/base
EOF

cat <<EOF > "kustomize/manifests/flux-kustomization/kubeflow/overlays/${KUBEFLOW_PROJECT}/kustomization.yaml"
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
namespace: flux-system
resources:
- ../../base
- ../../../external-secrets/overlays/${KUBEFLOW_PROJECT}
- ../../../external-dns/overlays/${KUBEFLOW_PROJECT}
- ../../../kubeflow/overlays/${KUBEFLOW_PROJECT}
patchesStrategicMerge:
- patch-flux-kustomization.yaml
EOF
