#!/bin/bash
function get_istio_ingressgateway_service() {
    kubectl get service -n istio-system -o json istio-ingressgateway \
      | jq
}

function get_istio_ingressgateway_service_type() {
  get_istio_ingressgateway_service \
    | jq -rc '.spec.type'
}

function get_istio_ingressgateway_loadbalancer_ip() {
  get_istio_ingressgateway_service \
    | jq -rc '.status.loadBalancer.ingress | first | .ip'
}

function get_istio_ingressgateway_loadbalancer_dns() {
  get_istio_ingressgateway_service |
    jq -rc '.metadata.annotations["external-dns.alpha.kubernetes.io/hostname"]'
}

function get_cluster_kustomize_path() {
  echo "${GITHUB_WORKSPACE}/kustomize/manifests/deploy/overlays/${CLUSTER_PROJECT}"
}

function setup_kubectl() {
  VERSION=$(curl -L -s https://dl.k8s.io/release/stable.txt)
  wget -s "https://dl.k8s.io/release/${VERSION}/bin/${OS}/${ARCH}/kubectl"
  chmod +x kubectl
  mv kubectl "${HOME}/.local/bin"
}

function setup_kubectl_darwin_amd64() {
  OS=darwin
  ARCH=amd64
  setup_kubectl
}

function setup_kubectl_linux_amd64() {
  OS=linux
  ARCH=amd64
  setup_kubectl
}

function setup_kustomize() {
  curl -s "https://raw.githubusercontent.com/kubernetes-sigs/kustomize/master/hack/install_kustomize.sh" \
    > "${GITHUB_WORKSPACE}/install_kustomize.sh"
  bash "${GITHUB_WORKSPACE}/install_kustomize.sh" "${HOME}/.local/bin"
  rm "${GITHUB_WORKSPACE}/install_kustomize.sh"
}

function setup_mc() {
  wget "https://dl.min.io/client/mc/release/${OS}-${ARCH}/mc"
  chmod +x mc
  mv mc "${HOME}/.local/bin"
}

function setup_mc_darwin_amd64() {
  OS=darwin
  ARCH=amd64
  setup_mc
}

function setup_mc_linux_amd64() {
  OS=linux
  ARCH=amd64
  setup_mc
}

function setup_flux() {
  wget https://fluxcd.io/install.sh
  bash "${GITHUB_WORKSPACE}/install.sh" "${HOME}/.local/bin"
  rm "${GITHUB_WORKSPACE}/install_kustomize.sh"
}
