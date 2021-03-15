#!/bin/bash
cd "$(dirname "$0")"
kubectl port-forward svc/argocd-server -n argocd 8443:443
