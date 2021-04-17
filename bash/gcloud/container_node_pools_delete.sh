#!/bin/bash
CLUSTER=$1
PROJECT=$2
ZONE=$3
gcloud container node-pools delete "${CLUSTER}-cpu-01" \
  --cluster="${CLUSTER}" \
  --project="${PROJECT}" \
  --zone="${ZONE}"
gcloud container node-pools delete "${CLUSTER}-gpu-01" \
  --cluster="${CLUSTER}" \
  --project="${PROJECT}" \
  --zone="${ZONE}"
