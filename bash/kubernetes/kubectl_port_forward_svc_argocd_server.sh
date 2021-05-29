#!/bin/bash
kubectl port-forward svc/argocd-server -n argocd 8443:443
