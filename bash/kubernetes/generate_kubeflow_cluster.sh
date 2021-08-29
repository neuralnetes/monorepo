#!/bin/bash
PATHS=(
  "kustomize/manifests/cloud-sdk/overlays/${KUBEFLOW_PROJECT}"
  "kustomize/manifests/external-secrets/overlays/${KUBEFLOW_PROJECT}"
  "kustomize/manifests/external-dns/overlays/${KUBEFLOW_PROJECT}"
  "kustomize/manifests/secrets/auth/overlays/${KUBEFLOW_PROJECT}"
  "kustomize/manifests/secrets/cert-manager/overlays/${KUBEFLOW_PROJECT}"
  "kustomize/manifests/secrets/kubeflow/overlays/${KUBEFLOW_PROJECT}"
  "kustomize/manifests/secrets/istio-system/overlays/${KUBEFLOW_PROJECT}"
  "kustomize/manifests/kubeflow/overlays/${KUBEFLOW_PROJECT}/common/cert-manager"
  "kustomize/manifests/kubeflow/overlays/${KUBEFLOW_PROJECT}/common/istio-1-9-0/istio-install/base"
  "kustomize/manifests/kubeflow/overlays/${KUBEFLOW_PROJECT}/common/oidc-authservice/base"
  "kustomize/manifests/kubeflow/overlays/${KUBEFLOW_PROJECT}/common/dex/overlays/istio"
  "kustomize/manifests/kubeflow/overlays/${KUBEFLOW_PROJECT}/common/knative/knative-serving-install/base"
  "kustomize/manifests/kubeflow/overlays/${KUBEFLOW_PROJECT}/common/istio-1-9-0/kubeflow-istio-resources/base"
  "kustomize/manifests/kubeflow-profiles/overlays/${KUBEFLOW_PROJECT}"
  "kustomize/manifests/deploy/overlays/${KUBEFLOW_PROJECT}"
  "kustomize/manifests/flux-kustomization/cloud-sdk/overlays/${KUBEFLOW_PROJECT}"
  "kustomize/manifests/flux-kustomization/external-secrets/overlays/${KUBEFLOW_PROJECT}"
  "kustomize/manifests/flux-kustomization/external-dns/overlays/${KUBEFLOW_PROJECT}"
  "kustomize/manifests/flux-kustomization/secrets/auth/overlays/${KUBEFLOW_PROJECT}"
  "kustomize/manifests/flux-kustomization/secrets/cert-manager/overlays/${KUBEFLOW_PROJECT}"
  "kustomize/manifests/flux-kustomization/secrets/kubeflow/overlays/${KUBEFLOW_PROJECT}"
  "kustomize/manifests/flux-kustomization/secrets/istio-system/overlays/${KUBEFLOW_PROJECT}"
  "kustomize/manifests/flux-kustomization/kubeflow/overlays/${KUBEFLOW_PROJECT}"
  "kustomize/manifests/flux-kustomization/kubeflow-profiles/overlays/${KUBEFLOW_PROJECT}"
  "kustomize/manifests/flux-kustomization/cluster/overlays/${KUBEFLOW_PROJECT}"
  "kustomize/manifests/flux-kustomization/deploy/overlays/${KUBEFLOW_PROJECT}"
)

for path in "${PATHS[@]}"; do
  rm -rf "${path}"
  mkdir -p "${path}"
done

# cloud-sdk
cat <<EOF >"kustomize/manifests/cloud-sdk/overlays/${KUBEFLOW_PROJECT}/patch-service-account.yaml"
apiVersion: v1
kind: ServiceAccount
metadata:
  name: cloud-sdk
  annotations:
    iam.gke.io/gcp-service-account: cloud-sdk@${IAM_PROJECT}.iam.gserviceaccount.com
EOF

cat <<EOF >"kustomize/manifests/cloud-sdk/overlays/${KUBEFLOW_PROJECT}/kustomization.yaml"
namespace: cloud-sdk
resources:
- ../../base
patchesStrategicMerge:
- patch-service-account.yaml
EOF

# profiles
cat <<EOF >"kustomize/manifests/kubeflow-profiles/overlays/${KUBEFLOW_PROJECT}/profile.yaml"
apiVersion: kubeflow.org/v1beta1
kind: Profile
metadata:
  name: alexander-lerma
spec:
  owner:
    kind: User
    name: alexander.lerma@${GCP_WORKSPACE_DOMAIN_NAME}
  resourceQuotaSpec: {}
  plugins:
  - kind: WorkloadIdentity
    spec:
      gcpServiceAccount: alexander-lerma@${IAM_PROJECT}.iam.gserviceaccount.com
---
apiVersion: kubeflow.org/v1beta1
kind: Profile
metadata:
  name: ian-macdonald
spec:
  owner:
    kind: User
    name: ian.macdonald@${GCP_WORKSPACE_DOMAIN_NAME}
  resourceQuotaSpec: {}
  plugins:
  - kind: WorkloadIdentity
    spec:
      gcpServiceAccount: ian-macdonald@${IAM_PROJECT}.iam.gserviceaccount.com
EOF

cat <<EOF >"kustomize/manifests/kubeflow-profiles/overlays/${KUBEFLOW_PROJECT}/kustomization.yaml"
resources:
- profile.yaml
EOF

# secrets
cat <<EOF >"kustomize/manifests/secrets/istio-system/overlays/${KUBEFLOW_PROJECT}/patch-certificate.yaml"
apiVersion: cert-manager.io/v1alpha2
kind: Certificate
metadata:
  name: istio-certs-letsencrypt-staging
spec:
  dnsNames:
  - '*.staging.n9s.mx'
---
apiVersion: cert-manager.io/v1alpha2
kind: Certificate
metadata:
  name: istio-certs-letsencrypt-prod
spec:
  dnsNames:
  - '*.staging.n9s.mx'
---
apiVersion: cert-manager.io/v1alpha2
kind: Certificate
metadata:
  name: istio-certs-self-signed
spec:
  dnsNames:
  - '*.staging.n9s.mx'
EOF

cat <<EOF >"kustomize/manifests/secrets/istio-system/overlays/${KUBEFLOW_PROJECT}/kustomization.yaml"
namespace: istio-system
resources:
- ../../base
patchesStrategicMerge:
- patch-certificate.yaml
EOF

cat <<EOF >"kustomize/manifests/secrets/kubeflow/overlays/${KUBEFLOW_PROJECT}/patch-external-secret.yaml"
apiVersion: kubernetes-client.io/v1
kind: ExternalSecret
metadata:
  name: katib-mysql-secrets
spec:
  backendType: gcpSecretsManager
  projectId: ${SECRET_PROJECT}
  data:
    - key: ${KUBEFLOW_PROJECT}-kubeflow-katib-mysql-secrets
      name: MYSQL_HOST
      property: MYSQL_HOST
      version: latest
    - key: ${KUBEFLOW_PROJECT}-kubeflow-katib-mysql-secrets
      name: MYSQL_PORT
      property: MYSQL_PORT
      version: latest
    - key: ${KUBEFLOW_PROJECT}-kubeflow-katib-mysql-secrets
      name: MYSQL_USER
      property: MYSQL_USER
      version: latest
    - key: ${KUBEFLOW_PROJECT}-kubeflow-katib-mysql-secrets
      name: MYSQL_PASSWORD
      property: MYSQL_PASSWORD
      version: latest
    - key: ${KUBEFLOW_PROJECT}-kubeflow-katib-mysql-secrets
      name: MYSQL_ROOT_PASSWORD
      property: MYSQL_ROOT_PASSWORD
      version: latest
EOF

cat <<EOF >"kustomize/manifests/secrets/kubeflow/overlays/${KUBEFLOW_PROJECT}/kustomization.yaml"
namespace: kubeflow
resources:
- ../../base
patchesStrategicMerge:
- patch-external-secret.yaml
EOF

cat <<EOF >"kustomize/manifests/secrets/cert-manager/overlays/${KUBEFLOW_PROJECT}/patch-external-secret.yaml"
apiVersion: kubernetes-client.io/v1
kind: ExternalSecret
metadata:
  name: service-account-key
spec:
  backendType: gcpSecretsManager
  projectId: ${SECRET_PROJECT}
  data:
    - key: ${KUBEFLOW_PROJECT}-cert-manager-service-account-key
      name: key.json
      version: latest
      isBinary: true
EOF

# auth
cat <<EOF >"kustomize/manifests/secrets/auth/overlays/${KUBEFLOW_PROJECT}/kustomization.yaml"
namespace: auth
resources:
- ../../base
patchesStrategicMerge:
- patch-external-secret.yaml
EOF

cat <<EOF >"kustomize/manifests/secrets/auth/overlays/${KUBEFLOW_PROJECT}/patch-external-secret.yaml"
apiVersion: kubernetes-client.io/v1
kind: ExternalSecret
metadata:
  name: service-account-key
spec:
  backendType: gcpSecretsManager
  projectId: ${SECRET_PROJECT}
  data:
    - key: ${KUBEFLOW_PROJECT}-auth-service-account-key
      name: key.json
      version: latest
      isBinary: true
---
apiVersion: kubernetes-client.io/v1
kind: ExternalSecret
metadata:
  name: dex-secrets
spec:
  backendType: gcpSecretsManager
  projectId: ${SECRET_PROJECT}
  data:
    - key: ${KUBEFLOW_PROJECT}-auth-dex-secrets
      name: GOOGLE_CLIENT_ID
      property: GOOGLE_CLIENT_ID
      version: latest
    - key: ${KUBEFLOW_PROJECT}-auth-dex-secrets
      name: GOOGLE_CLIENT_SECRET
      property: GOOGLE_CLIENT_SECRET
      version: latest
    - key: ${KUBEFLOW_PROJECT}-auth-dex-secrets
      name: GITHUB_CLIENT_ID
      property: GITHUB_CLIENT_ID
      version: latest
    - key: ${KUBEFLOW_PROJECT}-auth-dex-secrets
      name: GITHUB_CLIENT_SECRET
      property: GITHUB_CLIENT_SECRET
      version: latest
EOF

cat <<EOF >"kustomize/manifests/secrets/cert-manager/overlays/${KUBEFLOW_PROJECT}/kustomization.yaml"
namespace: cert-manager
resources:
- ../../base
patchesStrategicMerge:
- patch-external-secret.yaml
EOF

# external-secrets
cat <<EOF >"kustomize/manifests/external-secrets/overlays/${KUBEFLOW_PROJECT}/patch-service-account.yaml"
apiVersion: v1
kind: ServiceAccount
metadata:
  name: external-secrets
  annotations:
    iam.gke.io/gcp-service-account: external-secrets@${IAM_PROJECT}.iam.gserviceaccount.com
EOF

cat <<EOF >"kustomize/manifests/external-secrets/overlays/${KUBEFLOW_PROJECT}/kustomization.yaml"
namespace: external-secrets
resources:
- ../../base
patchesStrategicMerge:
- patch-service-account.yaml
EOF

# external-dns
cat <<EOF >"kustomize/manifests/external-dns/overlays/${KUBEFLOW_PROJECT}/patch-deployment.yaml"
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
        - --txt-owner-id=${KUBEFLOW_PROJECT}
EOF

cat <<EOF >"kustomize/manifests/external-dns/overlays/${KUBEFLOW_PROJECT}/patch-service-account.yaml"
apiVersion: v1
kind: ServiceAccount
metadata:
  name: external-dns
  annotations:
    iam.gke.io/gcp-service-account: external-dns@${IAM_PROJECT}.iam.gserviceaccount.com
EOF

cat <<EOF >"kustomize/manifests/external-dns/overlays/${KUBEFLOW_PROJECT}/kustomization.yaml"
namespace: external-dns
resources:
- ../../base
patchesStrategicMerge:
- patch-deployment.yaml
- patch-service-account.yaml
EOF

# cert-manager
cat <<EOF >"kustomize/manifests/kubeflow/overlays/${KUBEFLOW_PROJECT}/common/cert-manager/patch-cluster-issuer.yaml"
apiVersion: cert-manager.io/v1alpha2
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
            serviceAccountSecretRef:
              name: service-account-key
              key: key.json
---
apiVersion: cert-manager.io/v1alpha2
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
            serviceAccountSecretRef:
              name: service-account-key
              key: key.json

EOF

cat <<EOF >"kustomize/manifests/kubeflow/overlays/${KUBEFLOW_PROJECT}/common/cert-manager/kustomization.yaml"
namespace: cert-manager
resources:
- ../../../../../kubeflow/custom/common/cert-manager
patchesStrategicMerge:
- patch-cluster-issuer.yaml
EOF

# istio-install
cat <<EOF >"kustomize/manifests/kubeflow/overlays/${KUBEFLOW_PROJECT}/common/istio-1-9-0/istio-install/base/patch-service.yaml"
apiVersion: v1
kind: Service
metadata:
  name: istio-ingressgateway
  namespace: istio-system
  annotations:
    external-dns.alpha.kubernetes.io/hostname: '*.staging.n9s.mx.'
spec:
  type: LoadBalancer
  loadBalancerIP: '${ISTIO_INGRESSGATEWAY_LOAD_BALANCER_IP}'
EOF

cat <<EOF >"kustomize/manifests/kubeflow/overlays/${KUBEFLOW_PROJECT}/common/istio-1-9-0/istio-install/base/patch-gateway.yaml"
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

cat <<EOF >"kustomize/manifests/kubeflow/overlays/${KUBEFLOW_PROJECT}/common/istio-1-9-0/istio-install/base/kustomization.yaml"
namespace: istio-system
resources:
- ../../../../../../../kubeflow/base/common/istio-1-9-0/istio-install/base
patchesStrategicMerge:
- patch-gateway.yaml
- patch-service.yaml
EOF

# oidc-authservice
cat <<EOF >"kustomize/manifests/kubeflow/overlays/${KUBEFLOW_PROJECT}/common/oidc-authservice/base/patch-config-map.yaml"
apiVersion: v1
kind: ConfigMap
metadata:
  name: oidc-authservice-parameters
  namespace: istio-system
data:
  OIDC_AUTH_URL: /dex/auth
  OIDC_PROVIDER: https://kubeflow.staging.n9s.mx/dex
  OIDC_SCOPES: profile email groups
  PORT: '"8080"'
  REDIRECT_URL: /login/oidc
  SKIP_AUTH_URI: /dex
  STORE_PATH: /var/lib/authservice/data.db
  USERID_CLAIM: email
  USERID_HEADER: kubeflow-userid
  USERID_PREFIX: ""
EOF

cat <<EOF >"kustomize/manifests/kubeflow/overlays/${KUBEFLOW_PROJECT}/common/oidc-authservice/base/kustomization.yaml"
namespace: istio-system
resources:
- ../../../../../../kubeflow/base/common/oidc-authservice/base
patchesStrategicMerge:
- patch-config-map.yaml
EOF

## dex
cat <<EOF >"kustomize/manifests/kubeflow/overlays/${KUBEFLOW_PROJECT}/common/dex/overlays/istio/patch-config.yaml"
apiVersion: v1
kind: ConfigMap
metadata:
  name: dex
data:
  config.yaml: |
    issuer: https://kubeflow.staging.n9s.mx/dex
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
    enablePasswordDB: false
    staticClients:
    # https://github.com/dexidp/dex/pull/1664
    - id: kubeflow-oidc-authservice
      redirectURIs: ["/login/oidc"]
      name: 'Dex Login Application'
      secret: pUBnBOY80SnXgjibTYM9ZWNzY2xreNGQok
    connectors:
    - type: google
      id: google
      name: Google
      config:
        # Connector config values starting with a "$" will read from the environment.
        clientID: \$GOOGLE_CLIENT_ID
        clientSecret: \$GOOGLE_CLIENT_SECRET

        # Dex's issuer URL + "/callback"
        redirectURI: https://kubeflow.staging.n9s.mx/dex/callback
        serviceAccountFilePath: /etc/dex/service-account-key/key.json
    - type: github
      id: github
      name: GitHub
      config:
        # Connector config values starting with a "$" will read from the environment.
        clientID: \$GITHUB_CLIENT_ID
        clientSecret: \$GITHUB_CLIENT_SECRET
        redirectURI: https://kubeflow.staging.n9s.mx/dex/callback

EOF

cat <<EOF >"kustomize/manifests/kubeflow/overlays/${KUBEFLOW_PROJECT}/common/dex/overlays/istio/patch-deployment.yaml"
apiVersion: apps/v1
kind: Deployment
metadata:
  name: dex
spec:
  template:
    spec:
      containers:
      - image: quay.io/dexidp/dex:v2.22.0
        name: dex
        command: ["dex", "serve", "/etc/dex/cfg/config.yaml"]
        ports:
        - name: http
          containerPort: 5556
        volumeMounts:
        - name: config
          mountPath: /etc/dex/cfg
        - name: service-account-key
          mountPath: /etc/dex/service-account-key
        envFrom:
          - secretRef:
              name: dex-oidc-client
          - secretRef:
              name: dex-secrets
      volumes:
      - name: config
        configMap:
          name: dex
          items:
          - key: config.yaml
            path: config.yaml
      - name: service-account-key
        secret:
          secretName: service-account-key
EOF

cat <<EOF >"kustomize/manifests/kubeflow/overlays/${KUBEFLOW_PROJECT}/common/dex/overlays/istio/kustomization.yaml"
namespace: auth
resources:
- ../../../../../../../kubeflow/base/common/dex/overlays/istio
patchesStrategicMerge:
- patch-config.yaml
- patch-deployment.yaml
EOF

# knative-serving-install
cat <<EOF >"kustomize/manifests/kubeflow/overlays/${KUBEFLOW_PROJECT}/common/knative/knative-serving-install/base/patch-config.yaml"
apiVersion: v1
kind: ConfigMap
metadata:
  name: config-domain
  namespace: knative-serving
data:
  staging.n9s.mx: ""
---
apiVersion: v1
kind: ConfigMap
metadata:
  name: config-deployment
  namespace: knative-serving
data:
  registriesSkippingTagResolving: us-central1-docker.pkg.dev
EOF

cat <<EOF >"kustomize/manifests/kubeflow/overlays/${KUBEFLOW_PROJECT}/common/knative/knative-serving-install/base/kustomization.yaml"
namespace: knative-serving
resources:
- ../../../../../../../kubeflow/base/common/knative/knative-serving-install/base
patchesStrategicMerge:
- patch-config.yaml
EOF

# kubeflow-istio-resources
cat <<EOF >"kustomize/manifests/kubeflow/overlays/${KUBEFLOW_PROJECT}/common/istio-1-9-0/kubeflow-istio-resources/base/patch-gateway.yaml"
apiVersion: networking.istio.io/v1alpha3
kind: Gateway
metadata:
  name: kubeflow-gateway
spec:
  selector:
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

cat <<EOF >"kustomize/manifests/kubeflow/overlays/${KUBEFLOW_PROJECT}/common/istio-1-9-0/kubeflow-istio-resources/base/kustomization.yaml"
namespace: kubeflow
resources:
- ../../../../../../../kubeflow/base/common/istio-1-9-0/kubeflow-istio-resources/base
patchesStrategicMerge:
- patch-gateway.yaml
EOF

# deploy
cat <<EOF >"kustomize/manifests/deploy/overlays/${KUBEFLOW_PROJECT}/kustomization.yaml"
resources:
- ../../base
- ../../../flux-kustomization/cluster/overlays/${KUBEFLOW_PROJECT}
EOF

# flux-kustomization
cat <<EOF >"kustomize/manifests/flux-kustomization/external-secrets/overlays/${KUBEFLOW_PROJECT}/patch-flux-kustomization.yaml"
apiVersion: kustomize.toolkit.fluxcd.io/v1beta1
kind: Kustomization
metadata:
  name: external-secrets
spec:
  path: kustomize/manifests/external-secrets/overlays/${KUBEFLOW_PROJECT}
EOF

cat <<EOF >"kustomize/manifests/flux-kustomization/external-secrets/overlays/${KUBEFLOW_PROJECT}/kustomization.yaml"
resources:
- ../../base
patchesStrategicMerge:
- patch-flux-kustomization.yaml
EOF

cat <<EOF >"kustomize/manifests/flux-kustomization/external-dns/overlays/${KUBEFLOW_PROJECT}/patch-flux-kustomization.yaml"
apiVersion: kustomize.toolkit.fluxcd.io/v1beta1
kind: Kustomization
metadata:
  name: external-dns
spec:
  path: kustomize/manifests/external-dns/overlays/${KUBEFLOW_PROJECT}
EOF

cat <<EOF >"kustomize/manifests/flux-kustomization/external-dns/overlays/${KUBEFLOW_PROJECT}/kustomization.yaml"
resources:
- ../../base
patchesStrategicMerge:
- patch-flux-kustomization.yaml
EOF

cat <<EOF >"kustomize/manifests/flux-kustomization/secrets/kubeflow/overlays/${KUBEFLOW_PROJECT}/patch-flux-kustomization.yaml"
apiVersion: kustomize.toolkit.fluxcd.io/v1beta1
kind: Kustomization
metadata:
  name: kubeflow-secrets
spec:
  path: kustomize/manifests/secrets/kubeflow/overlays/${KUBEFLOW_PROJECT}
EOF

cat <<EOF >"kustomize/manifests/flux-kustomization/secrets/kubeflow/overlays/${KUBEFLOW_PROJECT}/kustomization.yaml"
resources:
- ../../base
patchesStrategicMerge:
- patch-flux-kustomization.yaml
EOF

cat <<EOF >"kustomize/manifests/flux-kustomization/secrets/istio-system/overlays/${KUBEFLOW_PROJECT}/patch-flux-kustomization.yaml"
apiVersion: kustomize.toolkit.fluxcd.io/v1beta1
kind: Kustomization
metadata:
  name: istio-system-secrets
spec:
  path: kustomize/manifests/secrets/istio-system/overlays/${KUBEFLOW_PROJECT}
EOF

cat <<EOF >"kustomize/manifests/flux-kustomization/secrets/istio-system/overlays/${KUBEFLOW_PROJECT}/kustomization.yaml"
resources:
- ../../base
patchesStrategicMerge:
- patch-flux-kustomization.yaml
EOF

cat <<EOF >"kustomize/manifests/flux-kustomization/secrets/cert-manager/overlays/${KUBEFLOW_PROJECT}/patch-flux-kustomization.yaml"
apiVersion: kustomize.toolkit.fluxcd.io/v1beta1
kind: Kustomization
metadata:
  name: cert-manager-secrets
spec:
  path: kustomize/manifests/secrets/cert-manager/overlays/${KUBEFLOW_PROJECT}
EOF

cat <<EOF >"kustomize/manifests/flux-kustomization/secrets/cert-manager/overlays/${KUBEFLOW_PROJECT}/kustomization.yaml"
resources:
- ../../base
patchesStrategicMerge:
- patch-flux-kustomization.yaml
EOF

cat <<EOF >"kustomize/manifests/flux-kustomization/secrets/auth/overlays/${KUBEFLOW_PROJECT}/patch-flux-kustomization.yaml"
apiVersion: kustomize.toolkit.fluxcd.io/v1beta1
kind: Kustomization
metadata:
  name: auth-secrets
spec:
  path: kustomize/manifests/secrets/auth/overlays/${KUBEFLOW_PROJECT}
EOF

cat <<EOF >"kustomize/manifests/flux-kustomization/secrets/auth/overlays/${KUBEFLOW_PROJECT}/kustomization.yaml"
resources:
- ../../base
patchesStrategicMerge:
- patch-flux-kustomization.yaml
EOF

cat <<EOF >"kustomize/manifests/flux-kustomization/kubeflow-profiles/overlays/${KUBEFLOW_PROJECT}/flux-kustomization.yaml"
apiVersion: kustomize.toolkit.fluxcd.io/v1beta1
kind: Kustomization
metadata:
  name: kubeflow-profiles
spec:
  interval: 1m
  path: kustomize/manifests/kubeflow-profiles/overlays/${KUBEFLOW_PROJECT}
  prune: true
  sourceRef:
    name: monorepo
    kind: GitRepository
  targetNamespace: flux-system
EOF

cat <<EOF >"kustomize/manifests/flux-kustomization/kubeflow-profiles/overlays/${KUBEFLOW_PROJECT}/kustomization.yaml"
resources:
- flux-kustomization.yaml
EOF

cat <<EOF >"kustomize/manifests/flux-kustomization/cloud-sdk/overlays/${KUBEFLOW_PROJECT}/patch-flux-kustomization.yaml"
apiVersion: kustomize.toolkit.fluxcd.io/v1beta1
kind: Kustomization
metadata:
  name: cloud-sdk
spec:
  path: kustomize/manifests/cloud-sdk/overlays/${KUBEFLOW_PROJECT}
EOF

cat <<EOF >"kustomize/manifests/flux-kustomization/cloud-sdk/overlays/${KUBEFLOW_PROJECT}/kustomization.yaml"
resources:
- ../../base
patchesStrategicMerge:
- patch-flux-kustomization.yaml
EOF

cat <<EOF >"kustomize/manifests/flux-kustomization/kubeflow/overlays/${KUBEFLOW_PROJECT}/patch-flux-kustomization.yaml"
---
apiVersion: kustomize.toolkit.fluxcd.io/v1beta1
kind: Kustomization
metadata:
  name: cert-manager
spec:
  path: kustomize/manifests/kubeflow/overlays/${KUBEFLOW_PROJECT}/common/cert-manager
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
  name: oidc-authservice
spec:
  path: kustomize/manifests/kubeflow/overlays/${KUBEFLOW_PROJECT}/common/oidc-authservice/base
---
apiVersion: kustomize.toolkit.fluxcd.io/v1beta1
kind: Kustomization
metadata:
  name: dex
spec:
  path: kustomize/manifests/kubeflow/overlays/${KUBEFLOW_PROJECT}/common/dex/overlays/istio
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
---
apiVersion: kustomize.toolkit.fluxcd.io/v1beta1
kind: Kustomization
metadata:
  name: katib
spec:
  path: kustomize/manifests/kubeflow/custom/apps/katib
EOF

cat <<EOF >"kustomize/manifests/flux-kustomization/kubeflow/overlays/${KUBEFLOW_PROJECT}/kustomization.yaml"
resources:
- ../../base
patchesStrategicMerge:
- patch-flux-kustomization.yaml
EOF

cat <<EOF >"kustomize/manifests/flux-kustomization/cluster/overlays/${KUBEFLOW_PROJECT}/patch-flux-kustomization.yaml"
apiVersion: kustomize.toolkit.fluxcd.io/v1beta1
kind: Kustomization
metadata:
  name: cluster
spec:
  path: kustomize/manifests/flux-kustomization/cluster/overlays/${KUBEFLOW_PROJECT}
EOF

cat <<EOF >"kustomize/manifests/flux-kustomization/cluster/overlays/${KUBEFLOW_PROJECT}/kustomization.yaml"
namespace: flux-system
resources:
- ../../base
- ../../../external-secrets/overlays/${KUBEFLOW_PROJECT}
- ../../../external-dns/overlays/${KUBEFLOW_PROJECT}
- ../../../secrets/auth/overlays/${KUBEFLOW_PROJECT}
- ../../../secrets/cert-manager/overlays/${KUBEFLOW_PROJECT}
- ../../../secrets/kubeflow/overlays/${KUBEFLOW_PROJECT}
- ../../../secrets/istio-system/overlays/${KUBEFLOW_PROJECT}
- ../../../kubeflow/overlays/${KUBEFLOW_PROJECT}
- ../../../kubeflow-profiles/overlays/${KUBEFLOW_PROJECT}
- ../../../cloud-sdk/overlays/${KUBEFLOW_PROJECT}
patchesStrategicMerge:
- patch-flux-kustomization.yaml
EOF
