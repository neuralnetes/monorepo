#!/bin/bash

gcloud container clusters get-credentials "${CLUSTER_NAME}" \
  --project="${CLUSTER_PROJECT}" \
  --zone="${CLUSTER_LOCATION}"
