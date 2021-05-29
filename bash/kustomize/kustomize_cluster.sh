#!/bin/bash
PATHS=(
  "kustomize/manifests/external-secrets/overlays/${KUBEFLOW_PROJECT}"
  "kustomize/manifests/external-dns/overlays/${KUBEFLOW_PROJECT}"
  "kustomize/manifests/secrets/cert-manager/overlays/${KUBEFLOW_PROJECT}"
  "kustomize/manifests/secrets/kubeflow/overlays/${KUBEFLOW_PROJECT}"
  "kustomize/manifests/secrets/istio-system/overlays/${KUBEFLOW_PROJECT}"
  "kustomize/manifests/kubeflow/overlays/${KUBEFLOW_PROJECT}/common/cert-manager"
  "kustomize/manifests/kubeflow/overlays/${KUBEFLOW_PROJECT}/common/istio-1-9-0/istio-install/base"
  "kustomize/manifests/kubeflow/overlays/${KUBEFLOW_PROJECT}/common/oidc-authservice/base"
  "kustomize/manifests/kubeflow/overlays/${KUBEFLOW_PROJECT}/common/dex/overlays/istio"
  "kustomize/manifests/kubeflow/overlays/${KUBEFLOW_PROJECT}/common/knative/knative-serving-install/base"
  "kustomize/manifests/kubeflow/overlays/${KUBEFLOW_PROJECT}/common/istio-1-9-0/kubeflow-istio-resources/base"
  "kustomize/manifests/deploy/overlays/${KUBEFLOW_PROJECT}"
  "kustomize/manifests/flux-kustomization/external-secrets/overlays/${KUBEFLOW_PROJECT}"
  "kustomize/manifests/flux-kustomization/external-dns/overlays/${KUBEFLOW_PROJECT}"
  "kustomize/manifests/flux-kustomization/secrets/kubeflow/overlays/${KUBEFLOW_PROJECT}"
  "kustomize/manifests/flux-kustomization/secrets/istio-system/overlays/${KUBEFLOW_PROJECT}"
  "kustomize/manifests/flux-kustomization/secrets/cert-manager/overlays/${KUBEFLOW_PROJECT}"
  "kustomize/manifests/flux-kustomization/kubeflow/overlays/${KUBEFLOW_PROJECT}"
  "kustomize/manifests/flux-kustomization/cluster/overlays/${KUBEFLOW_PROJECT}"
  "kustomize/manifests/flux-kustomization/deploy/overlays/${KUBEFLOW_PROJECT}"
)

for path in "${PATHS[@]}"; do
  rm -rf "${path}"
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
  - 'kubeflow.${KUBEFLOW_PROJECT}.${NETWORK_PROJECT}.${GCP_WORKSPACE_DOMAIN_NAME}'
EOF

cat <<EOF > "kustomize/manifests/secrets/istio-system/overlays/${KUBEFLOW_PROJECT}/kustomization.yaml"
namespace: istio-system
resources:
- ../../base
patchesStrategicMerge:
- patch-certificate.yaml
EOF

cat <<EOF > "kustomize/manifests/secrets/kubeflow/overlays/${KUBEFLOW_PROJECT}/patch-external-secret.yaml"
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

cat <<EOF > "kustomize/manifests/secrets/kubeflow/overlays/${KUBEFLOW_PROJECT}/kustomization.yaml"
namespace: kubeflow
resources:
- ../../base
patchesStrategicMerge:
- patch-external-secret.yaml
EOF

cat <<EOF > "kustomize/manifests/secrets/cert-manager/overlays/${KUBEFLOW_PROJECT}/patch-external-secret.yaml"
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
EOF

cat <<EOF > "kustomize/manifests/secrets/cert-manager/overlays/${KUBEFLOW_PROJECT}/kustomization.yaml"
namespace: cert-manager
resources:
- ../../base
patchesStrategicMerge:
- patch-external-secret.yaml
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

# cert-manager
cat <<EOF > "kustomize/manifests/kubeflow/overlays/${KUBEFLOW_PROJECT}/common/cert-manager/patch-cluster-issuer.yaml"
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
            project: ${NETWORK_PROJECT}
            serviceAccountSecretRef:
              name: service-account-key
              key: key.json
EOF

cat <<EOF > "kustomize/manifests/kubeflow/overlays/${KUBEFLOW_PROJECT}/common/cert-manager/kustomization.yaml"
namespace: cert-manager
resources:
- ../../../../../kubeflow/custom/common/cert-manager
patchesStrategicMerge:
- patch-cluster-issuer.yaml
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
    networking.gke.io/load-balancer-type: 'Internal'
spec:
  type: LoadBalancer
  loadBalancerIP: ${ISTIO_INGRESSGATEWAY_LOAD_BALANCER_IP}
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
    tls:
      httpsRedirect: true
  - port:
      number: 443
      name: https
      protocol: HTTPS
    tls:
      mode: SIMPLE
      credentialName: istio-certs
    hosts:
    - '*'
EOF

cat <<EOF > "kustomize/manifests/kubeflow/overlays/${KUBEFLOW_PROJECT}/common/istio-1-9-0/istio-install/base/kustomization.yaml"
namespace: istio-system
resources:
- ../../../../../../../kubeflow/base/common/istio-1-9-0/istio-install/base
patchesStrategicMerge:
- patch-gateway.yaml
- patch-service.yaml
EOF

# oidc-authservice
#cat <<EOF > "kustomize/manifests/kubeflow/overlays/${KUBEFLOW_PROJECT}/common/oidc-authservice/base/patch-config.yaml"
#kind: ConfigMap
#
#EOF

cat <<EOF > "kustomize/manifests/kubeflow/overlays/${KUBEFLOW_PROJECT}/common/oidc-authservice/base/kustomization.yaml"
namespace: kubeflow
resources:
- ../../../../../../kubeflow/base/common/oidc-authservice/base
EOF

## dex
cat <<EOF > "kustomize/manifests/kubeflow/overlays/${KUBEFLOW_PROJECT}/common/dex/overlays/istio/patch-config.yaml"
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
    staticClients:
    # https://github.com/dexidp/dex/pull/1664
    - idEnv: OIDC_CLIENT_ID
      redirectURIs: ["/login/oidc"]
      name: 'Dex Login Application'
      secretEnv: OIDC_CLIENT_SECRET
    connectors:
    - type: google
      id: google
      name: Google
      config:
        # Connector config values starting with a "$" will read from the environment.
        clientID: \$GOOGLE_CLIENT_ID
        clientSecret: \$GOOGLE_CLIENT_SECRET

        # Dex's issuer URL + "/callback"
        redirectURI: https://kubeflow.${KUBEFLOW_PROJECT}.${NETWORK_PROJECT}.${GCP_WORKSPACE_DOMAIN_NAME}/dex/callback
        serviceAccountFilePath: /etc/dex/dex-secret/key.json

EOF

cat <<EOF > "kustomize/manifests/kubeflow/overlays/${KUBEFLOW_PROJECT}/common/dex/overlays/istio/patch-deployment.yaml"
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
        - name: dex-secrets
          mountPath: /etc/dex/dex-secrets
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
      - name: dex-secrets
        secret:
          secretName: dex-secrets
EOF

cat <<EOF > "kustomize/manifests/kubeflow/overlays/${KUBEFLOW_PROJECT}/common/dex/overlays/istio/kustomization.yaml"
namespace: auth
resources:
- ../../../../../../../kubeflow/base/common/dex/overlays/istio
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
- ../../../../../../../kubeflow/base/common/knative/knative-serving-install/base
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
    tls:
      httpsRedirect: true
  - port:
      number: 443
      name: https
      protocol: HTTPS
    tls:
      mode: SIMPLE
      credentialName: istio-certs
    hosts:
    - '*'
EOF

cat <<EOF > "kustomize/manifests/kubeflow/overlays/${KUBEFLOW_PROJECT}/common/istio-1-9-0/kubeflow-istio-resources/base/kustomization.yaml"
namespace: kubeflow
resources:
- ../../../../../../../kubeflow/base/common/istio-1-9-0/kubeflow-istio-resources/base
patchesStrategicMerge:
- patch-gateway.yaml
EOF

# deploy
cat <<EOF > "kustomize/manifests/deploy/overlays/${KUBEFLOW_PROJECT}/kustomization.yaml"
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

cat <<EOF > "kustomize/manifests/flux-kustomization/secrets/cert-manager/overlays/${KUBEFLOW_PROJECT}/patch-flux-kustomization.yaml"
apiVersion: kustomize.toolkit.fluxcd.io/v1beta1
kind: Kustomization
metadata:
  name: cert-manager-secrets
spec:
  path: kustomize/manifests/secrets/cert-manager/overlays/${KUBEFLOW_PROJECT}
EOF

cat <<EOF > "kustomize/manifests/flux-kustomization/secrets/cert-manager/overlays/${KUBEFLOW_PROJECT}/kustomization.yaml"
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
- ../../../secrets/cert-manager/overlays/${KUBEFLOW_PROJECT}
- ../../../secrets/kubeflow/overlays/${KUBEFLOW_PROJECT}
- ../../../secrets/istio-system/overlays/${KUBEFLOW_PROJECT}
- ../../../kubeflow/overlays/${KUBEFLOW_PROJECT}
patchesStrategicMerge:
- patch-flux-kustomization.yaml
EOF
