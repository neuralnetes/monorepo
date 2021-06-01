#!/bin/bash
kustomize build --load-restrictor LoadRestrictionsNone "${KUSTOMIZE_PATH}" \
  | kubectl apply -f -
