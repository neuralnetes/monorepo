#!/bin/bash
cd "$(dirname "$0")"
INGRESS_HOST=$(kubectl -n istio-system get service istio-ingressgateway -o jsonpath='{.status.loadBalancer.ingress[0].ip}')
INGRESS_PORT=$(kubectl -n istio-system get service istio-ingressgateway -o jsonpath='{.spec.ports[?(@.name=="http2")].port}')
SECURE_INGRESS_PORT=$(kubectl -n istio-system get service istio-ingressgateway -o jsonpath='{.spec.ports[?(@.name=="https")].port}')
TCP_INGRESS_PORT=$(kubectl -n istio-system get service istio-ingressgateway -o jsonpath='{.spec.ports[?(@.name=="tcp")].port}')
GATEWAY_URL=$INGRESS_HOST:$INGRESS_PORT
NAMESPACE=default
kubectl label namespace "${NAMESPACE}" istio-injection=enabled
kubectl apply \
  -f https://raw.githubusercontent.com/istio/istio/release-1.7/samples/bookinfo/platform/kube/bookinfo.yaml \
  -n "${NAMESPACE}"
kubectl apply \
 -f https://raw.githubusercontent.com/istio/istio/release-1.7/samples/bookinfo/networking/bookinfo-gateway.yaml \
 -n "${NAMESPACE}"
kubectl exec "$(kubectl get pod -l app=ratings -o jsonpath='{.items[0].metadata.name}')" -c ratings -- curl productpage:9080/productpage | grep -o "<title>.*</title>"
curl -s "http://${GATEWAY_URL}/productpage" | grep -o "<title>.*</title>"