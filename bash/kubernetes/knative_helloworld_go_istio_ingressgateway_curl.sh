#!/bin/bash
cd "$(dirname "$0")"
echo 'apiVersion: serving.knative.dev/v1alpha1
kind: Service
metadata:
  name: helloworld-go
  namespace: default
spec:
  runLatest:
    configuration:
      revisionTemplate:
        spec:
          container:
            image: gcr.io/knative-samples/helloworld-go
            env:
            - name: TARGET
              value: "Knative"' | kubectl apply -f -
export ingressgateway=istio-ingressgateway
if kubectl get configmap config-istio -n knative-serving &> /dev/null; then
    export ingressgateway=istio-ingressgateway
fi
gateway_ip=$(kubectl get svc "${ingressgateway}" --namespace istio-system --output jsonpath="{.status.loadBalancer.ingress[*]['ip']}")
domain_name=$(kubectl get route helloworld-go -n default --output jsonpath="{.status.url}" | cut -d'/' -f 3)
echo -e "$gateway_ip\t$domain_name" | sudo tee -a /etc/hosts
sudo cat /etc/hosts