#!/bin/bash
PATHS=(
  "kustomize/manifests/external-secrets/overlays/${CLUSTER_NAME}"
  "kustomize/manifests/external-dns/overlays/${CLUSTER_NAME}"
  "kustomize/manifests/secrets/kubeflow/overlays/${CLUSTER_NAME}"
  "kustomize/manifests/secrets/istio-system/overlays/${CLUSTER_NAME}"
  "kustomize/manifests/kubeflow/1.3/overlays/${CLUSTER_NAME}/common/cert-manager/cert-manager/overlays/letsencrypt"
  "kustomize/manifests/kubeflow/1.3/overlays/${CLUSTER_NAME}/common/istio-1-9-0/istio-install/base"
  "kustomize/manifests/kubeflow/1.3/overlays/${CLUSTER_NAME}/common/oidc-authservice/base"
  "kustomize/manifests/kubeflow/1.3/overlays/${CLUSTER_NAME}/common/dex/overlays/istio"
  "kustomize/manifests/kubeflow/1.3/overlays/${CLUSTER_NAME}/common/knative/knative-serving-install/base"
  "kustomize/manifests/kubeflow/1.3/overlays/${CLUSTER_NAME}/common/istio-1-9-0/kubeflow-istio-resources/base"
  "kustomize/manifests/deploy/overlays/${CLUSTER_NAME}"
  "kustomize/manifests/flux-kustomization/external-secrets/overlays/${CLUSTER_NAME}"
  "kustomize/manifests/flux-kustomization/external-dns/overlays/${CLUSTER_NAME}"
  "kustomize/manifests/flux-kustomization/secrets/kubeflow/overlays/${CLUSTER_NAME}"
  "kustomize/manifests/flux-kustomization/secrets/istio-system/overlays/${CLUSTER_NAME}"
  "kustomize/manifests/flux-kustomization/kubeflow/1.3/overlays/${CLUSTER_NAME}"
  "kustomize/manifests/flux-kustomization/cluster/overlays/${CLUSTER_NAME}"
  "kustomize/manifests/flux-kustomization/deploy/overlays/${CLUSTER_NAME}"
)

for path in "${PATHS[@]}"; do
  mkdir -p "${path}"
done

# secrets

cat <<EOF > "kustomize/manifests/secrets/istio-system/overlays/${CLUSTER_NAME}/patch-certificate.yaml"
apiVersion: cert-manager.io/v1alpha2
kind: Certificate
metadata:
  name: istio-certs
spec:
  dnsNames:
  - '*.${CLUSTER_NAME}.${NETWORK_PROJECT}.com'
EOF

cat <<EOF > "kustomize/manifests/secrets/istio-system/overlays/${CLUSTER_NAME}/kustomization.yaml"
namespace: istio-system
resources:
- ../../base
patchesStrategicMerge:
- patch-certificate.yaml

EOF

# external-secrets
cat <<EOF > "kustomize/manifests/external-secrets/overlays/${CLUSTER_NAME}/patch-service-account.yaml"
apiVersion: v1
kind: ServiceAccount
metadata:
  name: external-secrets
  annotations:
    iam.gke.io/gcp-service-account: external-secrets@${IAM_PROJECT}.iam.gserviceaccount.com

EOF

cat <<EOF > "kustomize/manifests/external-secrets/overlays/${CLUSTER_NAME}/kustomization.yaml"
resources:
- ../../base
patchesStrategicMerge:
- patch-service-account.yaml

EOF

# external-dns
cat <<EOF > "kustomize/manifests/external-dns/overlays/${CLUSTER_NAME}/patch-deployment.yaml"
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
        - --txt-owner-id=external-dns-${CLUSTER_NAME}

EOF

cat <<EOF > "kustomize/manifests/external-dns/overlays/${CLUSTER_NAME}/patch-service-account.yaml"
apiVersion: v1
kind: ServiceAccount
metadata:
  name: external-dns
  annotations:
    iam.gke.io/gcp-service-account: external-dns@${IAM_PROJECT}.iam.gserviceaccount.com

EOF

cat <<EOF > "kustomize/manifests/external-dns/overlays/${CLUSTER_NAME}/kustomization.yaml"
resources:
- ../../base
patchesStrategicMerge:
- patch-deployment.yaml
- patch-service-account.yaml

EOF

# cert-manager
cat <<EOF > "kustomize/manifests/kubeflow/1.3/overlays/${CLUSTER_NAME}/common/cert-manager/cert-manager/overlays/letsencrypt/patch-cluster-issuer.yaml"
apiVersion: cert-manager.io/v1alpha2
kind: ClusterIssuer
metadata:
  name: letsencrypt-prod
spec:
  acme:
    email: bot+letsencrypt-prod@neuralnetes.com
    http01: null
    privateKeySecretRef: null
    server: https://acme-v02.api.letsencrypt.org/directory
    solvers:
      - dns01:
          cloudDNS:
            project: ${NETWORK_PROJECT}

EOF

cat <<EOF > "kustomize/manifests/kubeflow/1.3/overlays/${CLUSTER_NAME}/common/cert-manager/cert-manager/overlays/letsencrypt/cluster-issuer.yaml"
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

cat <<EOF > "kustomize/manifests/kubeflow/1.3/overlays/${CLUSTER_NAME}/common/cert-manager/cert-manager/overlays/letsencrypt/kustomization.yaml"
namespace: cert-manager
resources:
- ../../../../../../../../../kubeflow/1.3/base/common/cert-manager/cert-manager/overlays/letsencrypt
- cluster-issuer.yaml
patchesStrategicMerge:
- patch-cluster-issuer.yaml

EOF

# istio-install
cat <<EOF > "kustomize/manifests/kubeflow/1.3/overlays/${CLUSTER_NAME}/common/istio-1-9-0/istio-install/base/patch-service.yaml"
apiVersion: v1
kind: Service
metadata:
  name: istio-ingressgateway
  namespace: istio-system
  annotations:
    external-dns.alpha.kubernetes.io/hostname: '*.${CLUSTER_NAME}.${NETWORK_PROJECT}.com.'
spec:
  type: LoadBalancer

EOF

cat <<EOF > "kustomize/manifests/kubeflow/1.3/overlays/${CLUSTER_NAME}/common/istio-1-9-0/istio-install/base/patch-gateway.yaml"
apiVersion: networking.istio.io/v1alpha3
kind: Gateway
metadata:
  name: istio-ingressgateway
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
    - '*.${CLUSTER_NAME}.${NETWORK_PROJECT}.com'
EOF

cat <<EOF > "kustomize/manifests/kubeflow/1.3/overlays/${CLUSTER_NAME}/common/istio-1-9-0/istio-install/base/kustomization.yaml"
resources:
- ../../../../../../../../kubeflow/1.3/base/common/istio-1-9-0/istio-install/base
patchesStrategicMerge:
- patch-gateway.yaml
- patch-service.yaml

EOF

# oidc-authservice
#cat <<EOF > "kustomize/manifests/kubeflow/1.3/overlays/${CLUSTER_NAME}/common/oidc-authservice/base/patch-config.yaml"
#kind: ConfigMap
#
#EOF

cat <<EOF > "kustomize/manifests/kubeflow/1.3/overlays/${CLUSTER_NAME}/common/oidc-authservice/base/kustomization.yaml"
resources:
- ../../../../../../../kubeflow/1.3/base/common/oidc-authservice/base

EOF

# dex
cat <<EOF > "kustomize/manifests/kubeflow/1.3/overlays/${CLUSTER_NAME}/common/dex/overlays/istio/patch-config.yaml"
apiVersion: v1
kind: ConfigMap
metadata:
  name: dex
data:
  config.yaml: |
    issuer: http://dex.auth.svc.cluster.local:5556/dex
    storage:
      type: kubernetes
      config:
        inCluster: true
    web:
      http: 0.0.0.0:5556
    logger:
      level: "debug"
      format: text
    oauth2:
      skipApprovalScreen: true
    enablePasswordDB: true
    staticPasswords:
    - email: user@example.com
      hash: \$2y\$12\$4K/VkmDd1q1Orb3xAt82zu8gk7Ad6ReFR4LCP9UeYE90NLiN9Df72
      # https://github.com/dexidp/dex/pull/1601/commits
      # FIXME: Use hashFromEnv instead
      username: user
      userID: "15841185641784"
    staticClients:
    # https://github.com/dexidp/dex/pull/1664
    - idEnv: OIDC_CLIENT_ID
      redirectURIs: ["/login/oidc"]
      name: 'Dex Login Application'
      secretEnv: OIDC_CLIENT_SECRET

EOF

cat <<EOF > "kustomize/manifests/kubeflow/1.3/overlays/${CLUSTER_NAME}/common/dex/overlays/istio/kustomization.yaml"
resources:
- ../../../../../../../../kubeflow/1.3/base/common/dex/overlays/istio
patchesStrategicMerge:
- patch-config.yaml

EOF

# knative-serving-install
cat <<EOF > "kustomize/manifests/kubeflow/1.3/overlays/${CLUSTER_NAME}/common/knative/knative-serving-install/base/patch-config.yaml"
apiVersion: v1
kind: ConfigMap
metadata:
  name: config-domain
  namespace: knative-serving
data:
  ${CLUSTER_NAME}.${NETWORK_PROJECT}.com: ""

EOF

cat <<EOF > "kustomize/manifests/kubeflow/1.3/overlays/${CLUSTER_NAME}/common/knative/knative-serving-install/base/kustomization.yaml"
resources:
- ../../../kubeflow/1.3/common/knative/knative-serving-install/base
patchesStrategicMerge:
- patch-config.yaml

EOF

# kubeflow-istio-resources
cat <<EOF > "kustomize/manifests/kubeflow/1.3/overlays/${CLUSTER_NAME}/common/istio-1-9-0/kubeflow-istio-resources/base/patch-gateway.yaml"
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
    - '*.${CLUSTER_NAME}.${NETWORK_PROJECT}.com'
EOF

cat <<EOF > "kustomize/manifests/kubeflow/1.3/overlays/${CLUSTER_NAME}/common/istio-1-9-0/kubeflow-istio-resources/base/kustomization.yaml"
resources:
- ../../../../../../../../kubeflow/1.3/base/common/istio-1-9-0/kubeflow-istio-resources/base
patchesStrategicMerge:
- patch-gateway.yaml

EOF

# deploy
cat <<EOF > "kustomize/manifests/deploy/overlays/${CLUSTER_NAME}/kustomization.yaml"
namespace: flux-system
resources:
- ../../base
- ../../../flux-kustomization/cluster/overlays/${CLUSTER_NAME}

EOF

# flux-kustomization
cat <<EOF > "kustomize/manifests/flux-kustomization/external-secrets/overlays/${CLUSTER_NAME}/patch-flux-kustomization.yaml"
apiVersion: kustomize.toolkit.fluxcd.io/v1beta1
kind: Kustomization
metadata:
  name: external-secrets
spec:
  path: kustomize/manifests/external-secrets/overlays/${CLUSTER_NAME}

EOF

cat <<EOF > "kustomize/manifests/flux-kustomization/external-secrets/overlays/${CLUSTER_NAME}/kustomization.yaml"
resources:
- ../../base
patchesStrategicMerge:
- patch-flux-kustomization.yaml

EOF

cat <<EOF > "kustomize/manifests/flux-kustomization/external-dns/overlays/${CLUSTER_NAME}/patch-flux-kustomization.yaml"
apiVersion: kustomize.toolkit.fluxcd.io/v1beta1
kind: Kustomization
metadata:
  name: external-dns
spec:
  path: kustomize/manifests/external-dns/overlays/${CLUSTER_NAME}

EOF

cat <<EOF > "kustomize/manifests/flux-kustomization/external-dns/overlays/${CLUSTER_NAME}/kustomization.yaml"
resources:
- ../../base
patchesStrategicMerge:
- patch-flux-kustomization.yaml

EOF

cat <<EOF > "kustomize/manifests/flux-kustomization/secrets/kubeflow/overlays/${CLUSTER_NAME}/patch-flux-kustomization.yaml"
apiVersion: kustomize.toolkit.fluxcd.io/v1beta1
kind: Kustomization
metadata:
  name: kubeflow-secrets
spec:
  path: kustomize/manifests/secrets/kubeflow/overlays/${CLUSTER_NAME}

EOF

cat <<EOF > "kustomize/manifests/flux-kustomization/secrets/kubeflow/overlays/${CLUSTER_NAME}/kustomization.yaml"
resources:
- ../../base
patchesStrategicMerge:
- patch-flux-kustomization.yaml

EOF

cat <<EOF > "kustomize/manifests/flux-kustomization/secrets/istio-system/overlays/${CLUSTER_NAME}/patch-flux-kustomization.yaml"
apiVersion: kustomize.toolkit.fluxcd.io/v1beta1
kind: Kustomization
metadata:
  name: istio-system-secrets
spec:
  path: kustomize/manifests/secrets/istio-system/overlays/${CLUSTER_NAME}

EOF

cat <<EOF > "kustomize/manifests/flux-kustomization/secrets/istio-system/overlays/${CLUSTER_NAME}/kustomization.yaml"
resources:
- ../../base
patchesStrategicMerge:
- patch-flux-kustomization.yaml

EOF

cat <<EOF > "kustomize/manifests/flux-kustomization/kubeflow/1.3/overlays/${CLUSTER_NAME}/patch-flux-kustomization.yaml"
apiVersion: kustomize.toolkit.fluxcd.io/v1beta1
kind: Kustomization
metadata:
  name: cert-manager
spec:
  path: kustomize/manifests/kubeflow/1.3/overlays/${CLUSTER_NAME}/common/cert-manager/cert-manager/overlays/letsencrypt
---
apiVersion: kustomize.toolkit.fluxcd.io/v1beta1
kind: Kustomization
metadata:
  name: istio-install
spec:
  path: kustomize/manifests/kubeflow/1.3/overlays/${CLUSTER_NAME}/common/istio-1-9-0/istio-install/base
---
apiVersion: kustomize.toolkit.fluxcd.io/v1beta1
kind: Kustomization
metadata:
  name: oidc-authservice
spec:
  path: kustomize/manifests/kubeflow/1.3/overlays/${CLUSTER_NAME}/common/oidc-authservice/base
---
apiVersion: kustomize.toolkit.fluxcd.io/v1beta1
kind: Kustomization
metadata:
  name: dex
spec:
  path: kustomize/manifests/kubeflow/1.3/overlays/${CLUSTER_NAME}/common/dex/overlays/istio
---
apiVersion: kustomize.toolkit.fluxcd.io/v1beta1
kind: Kustomization
metadata:
  name: knative-serving-install
spec:
  path: kustomize/manifests/kubeflow/1.3/overlays/${CLUSTER_NAME}/common/knative/knative-serving-install/base
---
apiVersion: kustomize.toolkit.fluxcd.io/v1beta1
kind: Kustomization
metadata:
  name: kubeflow-istio-resources
spec:
  path: kustomize/manifests/kubeflow/1.3/overlays/${CLUSTER_NAME}/common/istio-1-9-0/kubeflow-istio-resources/base

EOF

cat <<EOF > "kustomize/manifests/flux-kustomization/kubeflow/1.3/overlays/${CLUSTER_NAME}/kustomization.yaml"
resources:
- ../../base
patchesStrategicMerge:
- patch-flux-kustomization.yaml

EOF

cat <<EOF > "kustomize/manifests/flux-kustomization/cluster/overlays/${CLUSTER_NAME}/patch-flux-kustomization.yaml"
apiVersion: kustomize.toolkit.fluxcd.io/v1beta1
kind: Kustomization
metadata:
  name: cluster
spec:
  path: kustomize/manifests/flux-kustomization/cluster/overlays/${CLUSTER_NAME}

EOF

cat <<EOF > "kustomize/manifests/flux-kustomization/cluster/overlays/${CLUSTER_NAME}/kustomization.yaml"
resources:
- ../../base
- ../../../external-secrets/overlays/${CLUSTER_NAME}
- ../../../external-dns/overlays/${CLUSTER_NAME}
- ../../../secrets/kubeflow/overlays/${CLUSTER_NAME}
- ../../../secrets/istio-system/overlays/${CLUSTER_NAME}
- ../../../kubeflow/1.3/overlays/${CLUSTER_NAME}
patchesStrategicMerge:
- patch-flux-kustomization.yaml

EOF
