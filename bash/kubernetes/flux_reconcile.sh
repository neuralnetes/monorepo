#!/bin/bash
kubectl get kustomizations.kustomize.toolkit.fluxcd.io -n flux-system -o json \
  | jq -rc \
    --arg github_sha "${GITHUB_SHA}" \
    '.items[] | select(.status.conditions | first | .message | split("/") | last != $github_sha) | .metadata.name' \
  | while read -r kustomization_name; do
      flux reconcile kustomization "${kustomization_name}" &
    done
wait
