#!/bin/bash
cd "$(dirname "$0")"
NAMESPACE=${1}
NAMESPACE_JSON=$(kubectl get ns "${NAMESPACE}" -o json)
NAMESPACE_EMPTY_FINALIZERS_JSON=$(echo "${NAMESPACE_JSON}" | jq ".spec.finalizers = []")
kubectl proxy &
PID=$!
sleep 5
curl -X PUT "http://localhost:8001/api/v1/namespaces/${NAMESPACE}/finalize" \
  -H "Content-Type: application/json" \
  -d "${NAMESPACE_EMPTY_FINALIZERS_JSON}"
kill $PID
