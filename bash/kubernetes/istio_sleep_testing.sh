#!/bin/bash
SLEEP_NAMESPACE=foo
kubectl create namespace "${SLEEP_NAMESPACE}"
kubectl label namespace "${SLEEP_NAMESPACE}" istio-injection=enabled
kubectl apply \
  -f https://github.com/istio/istio/blob/master/samples/sleep/sleep.yaml \
  -n "${SLEEP_NAMESPACE}"
kubectl exec "$(kubectl get pod -l app=sleep -n foo -o jsonpath={.items..metadata.name})" \
  -c sleep \
  -n "${SLEEP_NAMESPACE}" \
  -- curl -sS istiod.istio-system:15014/debug/endpointz | jq