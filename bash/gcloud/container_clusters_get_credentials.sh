#!/bin/bash
project_id="${1}"
region="${2}"
cluster_name="${3}"
gcloud container clusters get-credentials "${cluster_name}" \
  --project "${project_id}" \
  --region "${region}"
