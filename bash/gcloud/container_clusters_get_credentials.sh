#!/bin/bash
CLUSTER=$1
PROJECT=$2
ZONE=$3
gcloud container clusters get-credentials "${CLUSTER}" \
  --project "${PROJECT}" \
  --zone "${ZONE}"
