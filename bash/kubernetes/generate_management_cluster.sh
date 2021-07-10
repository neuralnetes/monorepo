#!/bin/bash
PATHS=(
  "kustomize/manifests/cloud-sdk/overlays/${MANAGEMENT_PROJECT}"
  "kustomize/manifests/cert-manager/overlays/${MANAGEMENT_PROJECT}"
  "kustomize/manifests/external-dns/overlays/${MANAGEMENT_PROJECT}"
  "kustomize/manifests/istio-system/overlays/${MANAGEMENT_PROJECT}"
  "kustomize/manifests/secrets/istio-system/overlays/${MANAGEMENT_PROJECT}"
  "kustomize/manifests/deploy/overlays/${MANAGEMENT_PROJECT}"
  "kustomize/manifests/flux-kustomization/cloud-sdk/overlays/${MANAGEMENT_PROJECT}"
  "kustomize/manifests/flux-kustomization/cert-manager/overlays/${MANAGEMENT_PROJECT}"
  "kustomize/manifests/flux-kustomization/external-secrets/overlays/${MANAGEMENT_PROJECT}"
  "kustomize/manifests/flux-kustomization/external-dns/overlays/${MANAGEMENT_PROJECT}"
  "kustomize/manifests/flux-kustomization/istio-system/overlays/${MANAGEMENT_PROJECT}"
  "kustomize/manifests/flux-kustomization/secrets/istio-system/overlays/${MANAGEMENT_PROJECT}"
  "kustomize/manifests/flux-kustomization/deploy/overlays/${MANAGEMENT_PROJECT}"
  "kustomize/manifests/flux-kustomization/cluster/overlays/${MANAGEMENT_PROJECT}"
)

for path in "${PATHS[@]}"; do
  rm -rf "${path}"
  mkdir -p "${path}"
done

# cloud-sdk
cat <<EOF >"kustomize/manifests/cloud-sdk/overlays/${MANAGEMENT_PROJECT}/patch-service-account.yaml"
apiVersion: v1
kind: ServiceAccount
metadata:
  name: cloud-sdk
  annotations:
    iam.gke.io/gcp-service-account: cloud-sdk@${IAM_PROJECT}.iam.gserviceaccount.com
EOF

cat <<EOF >"kustomize/manifests/cloud-sdk/overlays/${MANAGEMENT_PROJECT}/kustomization.yaml"
namespace: cloud-sdk
resources:
- ../../base
patchesStrategicMerge:
- patch-service-account.yaml
EOF

# secrets
cat <<EOF >"kustomize/manifests/secrets/istio-system/overlays/${MANAGEMENT_PROJECT}/patch-certificate.yaml"
apiVersion: cert-manager.io/v1alpha2
kind: Certificate
metadata:
  name: istio-certs-letsencrypt-staging
spec:
  dnsNames:
  - '*.n9s.mx'
---
apiVersion: cert-manager.io/v1alpha2
kind: Certificate
metadata:
  name: istio-certs-letsencrypt-prod
spec:
  dnsNames:
  - '*.n9s.mx'
---
apiVersion: cert-manager.io/v1alpha2
kind: Certificate
metadata:
  name: istio-certs-self-signed
spec:
  dnsNames:
  - '*.n9s.mx'
EOF

cat <<EOF >"kustomize/manifests/secrets/istio-system/overlays/${MANAGEMENT_PROJECT}/kustomization.yaml"
namespace: istio-system
resources:
- ../../base
patchesStrategicMerge:
- patch-certificate.yaml
EOF

# external-secrets
cat <<EOF >"kustomize/manifests/external-secrets/overlays/${MANAGEMENT_PROJECT}/patch-service-account.yaml"
apiVersion: v1
kind: ServiceAccount
metadata:
  name: external-secrets
  annotations:
    iam.gke.io/gcp-service-account: external-secrets@${IAM_PROJECT}.iam.gserviceaccount.com
EOF

cat <<EOF >"kustomize/manifests/external-secrets/overlays/${MANAGEMENT_PROJECT}/kustomization.yaml"
namespace: external-secrets
resources:
- ../../base
patchesStrategicMerge:
- patch-service-account.yaml
EOF

# external-dns
cat <<EOF >"kustomize/manifests/external-dns/overlays/${MANAGEMENT_PROJECT}/patch-deployment.yaml"
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
        - --google-project=${DNS_PROJECT}
        - --registry=txt
        - --txt-owner-id=${MANAGEMENT_PROJECT}
EOF

cat <<EOF >"kustomize/manifests/external-dns/overlays/${MANAGEMENT_PROJECT}/patch-service-account.yaml"
apiVersion: v1
kind: ServiceAccount
metadata:
  name: external-dns
  annotations:
    iam.gke.io/gcp-service-account: external-dns@${IAM_PROJECT}.iam.gserviceaccount.com
EOF

cat <<EOF >"kustomize/manifests/external-dns/overlays/${MANAGEMENT_PROJECT}/kustomization.yaml"
namespace: external-dns
resources:
- ../../base
patchesStrategicMerge:
- patch-deployment.yaml
- patch-service-account.yaml
EOF

# cert-manager
cat <<EOF >"kustomize/manifests/cert-manager/overlays/${MANAGEMENT_PROJECT}/patch-service-account.yaml"
apiVersion: v1
kind: ServiceAccount
metadata:
  name: cert-manager
  annotations:
    iam.gke.io/gcp-service-account: cert-manager@${IAM_PROJECT}.iam.gserviceaccount.com
EOF

cat <<EOF >"kustomize/manifests/cert-manager/overlays/${MANAGEMENT_PROJECT}/patch-cluster-issuer.yaml"
apiVersion: cert-manager.io/v1
kind: ClusterIssuer
metadata:
  name: letsencrypt-staging
spec:
  acme:
    email: bot+letencrypt-staging@${GCP_WORKSPACE_DOMAIN_NAME}
    solvers:
      - dns01:
          clouddns:
            project: ${DNS_PROJECT}
---
apiVersion: cert-manager.io/v1
kind: ClusterIssuer
metadata:
  name: letsencrypt-prod
spec:
  acme:
    email: bot+letencrypt-prod@${GCP_WORKSPACE_DOMAIN_NAME}
    solvers:
      - dns01:
          clouddns:
            project: ${DNS_PROJECT}
EOF

cat <<EOF >"kustomize/manifests/cert-manager/overlays/${MANAGEMENT_PROJECT}/kustomization.yaml"
namespace: cert-manager
resources:
- ../../base
patchesStrategicMerge:
- patch-service-account.yaml
- patch-cluster-issuer.yaml
EOF

# istio-install
cat <<EOF >"kustomize/manifests/istio-system/overlays/${MANAGEMENT_PROJECT}/patch-service.yaml"
apiVersion: v1
kind: Service
metadata:
  name: istio-ingressgateway
  namespace: istio-system
  annotations:
    external-dns.alpha.kubernetes.io/hostname: '*.n9s.mx.'
spec:
  type: LoadBalancer
  loadBalancerIP: '${ISTIO_INGRESSGATEWAY_LOAD_BALANCER_IP}'
EOF

cat <<EOF >"kustomize/manifests/istio-system/overlays/${MANAGEMENT_PROJECT}/patch-gateway.yaml"
apiVersion: networking.istio.io/v1alpha3
kind: Gateway
metadata:
  name: istio-ingressgateway
  labels:
    release: istio
spec:
  selector:
    app: istio-ingressgateway
    istio: ingressgateway
  servers:
  - port:
      number: 80
      name: http
      protocol: HTTP
    tls:
      httpsRedirect: true
    hosts:
    - '*'
  - port:
      number: 443
      name: https
      protocol: HTTPS
    tls:
      mode: SIMPLE
      credentialName: istio-certs-letsencrypt-prod
    hosts:
    - '*'
EOF

cat <<EOF >"kustomize/manifests/istio-system/overlays/${MANAGEMENT_PROJECT}/kustomization.yaml"
namespace: istio-system
resources:
- ../../base
patchesStrategicMerge:
- patch-gateway.yaml
- patch-service.yaml
EOF

# deploy
cat <<EOF >"kustomize/manifests/deploy/overlays/${MANAGEMENT_PROJECT}/kustomization.yaml"
resources:
- ../../base
- ../../../flux-kustomization/cluster/overlays/${MANAGEMENT_PROJECT}
EOF

# flux-kustomization
cat <<EOF >"kustomize/manifests/flux-kustomization/external-secrets/overlays/${MANAGEMENT_PROJECT}/patch-flux-kustomization.yaml"
apiVersion: kustomize.toolkit.fluxcd.io/v1beta1
kind: Kustomization
metadata:
  name: external-secrets
spec:
  path: kustomize/manifests/external-secrets/overlays/${MANAGEMENT_PROJECT}
EOF

cat <<EOF >"kustomize/manifests/flux-kustomization/external-secrets/overlays/${MANAGEMENT_PROJECT}/kustomization.yaml"
resources:
- ../../base
patchesStrategicMerge:
- patch-flux-kustomization.yaml
EOF

cat <<EOF >"kustomize/manifests/flux-kustomization/external-dns/overlays/${MANAGEMENT_PROJECT}/patch-flux-kustomization.yaml"
apiVersion: kustomize.toolkit.fluxcd.io/v1beta1
kind: Kustomization
metadata:
  name: external-dns
spec:
  path: kustomize/manifests/external-dns/overlays/${MANAGEMENT_PROJECT}
EOF

cat <<EOF >"kustomize/manifests/flux-kustomization/external-dns/overlays/${MANAGEMENT_PROJECT}/kustomization.yaml"
resources:
- ../../base
patchesStrategicMerge:
- patch-flux-kustomization.yaml
EOF

cat <<EOF >"kustomize/manifests/flux-kustomization/cert-manager/overlays/${MANAGEMENT_PROJECT}/patch-flux-kustomization.yaml"
apiVersion: kustomize.toolkit.fluxcd.io/v1beta1
kind: Kustomization
metadata:
  name: cert-manager
spec:
  path: kustomize/manifests/cert-manager/overlays/${MANAGEMENT_PROJECT}
EOF

cat <<EOF >"kustomize/manifests/flux-kustomization/cert-manager/overlays/${MANAGEMENT_PROJECT}/kustomization.yaml"
resources:
- ../../base
patchesStrategicMerge:
- patch-flux-kustomization.yaml
EOF

cat <<EOF >"kustomize/manifests/flux-kustomization/istio-system/overlays/${MANAGEMENT_PROJECT}/patch-flux-kustomization.yaml"
apiVersion: kustomize.toolkit.fluxcd.io/v1beta1
kind: Kustomization
metadata:
  name: istio-system
spec:
  path: kustomize/manifests/istio-system/overlays/${MANAGEMENT_PROJECT}
EOF

cat <<EOF >"kustomize/manifests/flux-kustomization/istio-system/overlays/${MANAGEMENT_PROJECT}/kustomization.yaml"
resources:
- ../../base
patchesStrategicMerge:
- patch-flux-kustomization.yaml
EOF

cat <<EOF >"kustomize/manifests/flux-kustomization/secrets/istio-system/overlays/${MANAGEMENT_PROJECT}/patch-flux-kustomization.yaml"
apiVersion: kustomize.toolkit.fluxcd.io/v1beta1
kind: Kustomization
metadata:
  name: istio-system-secrets
spec:
  path: kustomize/manifests/secrets/istio-system/overlays/${MANAGEMENT_PROJECT}
EOF

cat <<EOF >"kustomize/manifests/flux-kustomization/secrets/istio-system/overlays/${MANAGEMENT_PROJECT}/kustomization.yaml"
resources:
- ../../base
patchesStrategicMerge:
- patch-flux-kustomization.yaml
EOF

cat <<EOF >"kustomize/manifests/flux-kustomization/cloud-sdk/overlays/${MANAGEMENT_PROJECT}/patch-flux-kustomization.yaml"
apiVersion: kustomize.toolkit.fluxcd.io/v1beta1
kind: Kustomization
metadata:
  name: cloud-sdk
spec:
  path: kustomize/manifests/cloud-sdk/overlays/${MANAGEMENT_PROJECT}
EOF

cat <<EOF >"kustomize/manifests/flux-kustomization/cloud-sdk/overlays/${MANAGEMENT_PROJECT}/kustomization.yaml"
resources:
- ../../base
patchesStrategicMerge:
- patch-flux-kustomization.yaml
EOF

cat <<EOF >"kustomize/manifests/flux-kustomization/cert-manager/overlays/${MANAGEMENT_PROJECT}/patch-flux-kustomization.yaml"
---
apiVersion: kustomize.toolkit.fluxcd.io/v1beta1
kind: Kustomization
metadata:
  name: cert-manager
spec:
  path: kustomize/manifests/cert-manager/overlays/${MANAGEMENT_PROJECT}
EOF

cat <<EOF >"kustomize/manifests/flux-kustomization/cert-manager/overlays/${MANAGEMENT_PROJECT}/kustomization.yaml"
resources:
- ../../base
patchesStrategicMerge:
- patch-flux-kustomization.yaml
EOF

cat <<EOF >"kustomize/manifests/flux-kustomization/istio-system/overlays/${MANAGEMENT_PROJECT}/patch-flux-kustomization.yaml"
---
apiVersion: kustomize.toolkit.fluxcd.io/v1beta1
kind: Kustomization
metadata:
  name: istio-system
spec:
  path: kustomize/manifests/istio-system/overlays/${MANAGEMENT_PROJECT}
EOF

cat <<EOF >"kustomize/manifests/flux-kustomization/istio-system/overlays/${MANAGEMENT_PROJECT}/kustomization.yaml"
resources:
- ../../base
patchesStrategicMerge:
- patch-flux-kustomization.yaml
EOF

cat <<EOF >"kustomize/manifests/flux-kustomization/cluster/overlays/${MANAGEMENT_PROJECT}/patch-flux-kustomization.yaml"
apiVersion: kustomize.toolkit.fluxcd.io/v1beta1
kind: Kustomization
metadata:
  name: cluster
spec:
  path: kustomize/manifests/flux-kustomization/cluster/overlays/${MANAGEMENT_PROJECT}
EOF

cat <<EOF >"kustomize/manifests/flux-kustomization/cluster/overlays/${MANAGEMENT_PROJECT}/kustomization.yaml"
namespace: flux-system
resources:
- ../../base
- ../../../cert-manager/overlays/${MANAGEMENT_PROJECT}
- ../../../external-secrets/overlays/${MANAGEMENT_PROJECT}
- ../../../external-dns/overlays/${MANAGEMENT_PROJECT}
- ../../../istio-system/overlays/${MANAGEMENT_PROJECT}
- ../../../secrets/istio-system/overlays/${MANAGEMENT_PROJECT}
- ../../../cloud-sdk/overlays/${MANAGEMENT_PROJECT}
patchesStrategicMerge:
- patch-flux-kustomization.yaml
EOF
