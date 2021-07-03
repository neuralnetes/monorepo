#!/bin/bash
function setup_kubectl() {
  curl -s -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/${OS}/${ARCH}/kubectl"
  chmod +x kubectl
  mv kubectl "${HOME}/.local/bin"
}

function setup_kustomize() {
  if [[ ! -f "${HOME}/.local/bin/kubectl" ]]; then
    curl -s "https://raw.githubusercontent.com/kubernetes-sigs/kustomize/master/hack/install_kustomize.sh" \
      >"${GITHUB_WORKSPACE}/install_kustomize.sh"
    bash "${GITHUB_WORKSPACE}/install_kustomize.sh" "${HOME}/.local/bin"
    rm "${GITHUB_WORKSPACE}/install_kustomize.sh"
  fi
}

function setup_mc() {
  if [[ ! -f "${HOME}/.local/bin/mc" ]]; then
    wget "https://dl.min.io/client/mc/release/${OS}-${ARCH}/mc"
    chmod +x mc
    mv mc "${HOME}/.local/bin"
  fi
}

function setup_flux() {
  if [[ ! -f "${HOME}/.local/bin/flux" ]]; then
    if [[ "${OS}" == "darwin" ]]; then
      OS="Darwin"
    elif [[ "${OS}" == "linux" ]]; then
      OS="Linux"
    fi
    wget https://fluxcd.io/install.sh
    bash "${GITHUB_WORKSPACE}/install.sh" "${HOME}/.local/bin"
    rm -rf "${GITHUB_WORKSPACE}/install.sh"
  fi
}

function get_istio_ingressgateway_service() {
  kubectl get service -n istio-system -o json istio-ingressgateway |
    jq
}

function get_istio_ingressgateway_service_type() {
  get_istio_ingressgateway_service |
    jq -rc '.spec.type'
}

function get_istio_ingressgateway_load_balancer_ip() {
  get_istio_ingressgateway_service |
    jq -rc '.status.loadBalancer.ingress | first | .ip'
}

function get_istio_ingressgateway_loadbalancer_dns() {
  get_istio_ingressgateway_service |
    jq -rc '.metadata.annotations["external-dns.alpha.kubernetes.io/hostname"]'
}

function get_kustomization_path() {
  echo "${GITHUB_WORKSPACE}/kustomize/manifests/deploy/overlays/${CLUSTER_PROJECT}"
}

function get_kubeflow_kustomization_paths() {
  KUBEFLOW_KUSTOMIZATION_PATHS=(
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
  echo "${KUBEFLOW_KUSTOMIZATION_PATHS[@]}"
}

function mkdir_kustomization_paths() {
  for path in "${KUBEFLOW_KUSTOMIZATION_PATHS[@]}"; do
    mkdir -p "${path}"
  done
}

function rm_kustomization_paths() {
  REMOVE_PARENT="${1:-false}"
  for path in "${KUBEFLOW_KUSTOMIZATION_PATHS[@]}"; do
    if [[ "${REMOVE_PARENT}" ]]; then
      parent="$(dirname "${path}")"
      rm -rf "${parent}"/*
    else
      rm -rf "${path}"
    fi
  done
}

function generate_kubeflow_cluster() {
  KUBEFLOW_KUSTOMIZATION_PATHS=($(get_kubeflow_kustomization_paths))
  REMOVE_PARENT=true
  rm_kustomization_paths "${REMOVE_PARENT}"
  mkdir_kustomization_paths
  bash "${GITHUB_WORKSPACE}/bash/kubernetes/generate_kubeflow_cluster.sh"
}
