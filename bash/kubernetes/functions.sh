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

function setup_kubectx() {
  bash "${GITHUB_WORKSPACE}/bash/kubernetes/setup_kubectx.sh"
}
