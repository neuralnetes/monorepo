#!/bin/bash
cd "$(dirname "$0")"
PROJECT=${1}
LIEN_JSON=$(gcloud alpha resource-manager liens list --project="${PROJECT}" --format=json --quiet)
if [ "${LIEN_JSON}" == "[]" ]; then
    echo "No liens to delete for project ${PROJECT}"
    exit
fi
LIEN_NAME=$(echo "${LIEN_JSON}" | jq -r 'first | .name | split("/") | last')
gcloud alpha resource-manager liens delete "${LIEN_NAME}" --project="${PROJECT}" --quiet
