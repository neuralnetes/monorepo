#!/bin/bash
kustomize build --load-restrictor LoadRestrictionsNone "${CLUSTER_KUSTOMIZE_PATH}" \
  | kubectl apply -f -
