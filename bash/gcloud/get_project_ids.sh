#!/bin/bash

function get_project_id_by_prefix() {
    PROJECT_ID_PREFIX=$1
    gcloud projects list --format=json \
      | jq -rc  --arg project_id_prefix "${PROJECT_ID_PREFIX}" \
      '.[] | select(.projectId | startswith($project_id_prefix)) | .projectId'
}

IAM_PROJECT=$(get_project_id_by_prefix "iam")
SECRET_PROJECT=$(get_project_id_by_prefix "secret")
NETWORK_PROJECT=$(get_project_id_by_prefix "network")
DATA_PROJECT=$(get_project_id_by_prefix "data")
COMPUTE_PROJECT=$(get_project_id_by_prefix "compute")
KUBEFLOW_PROJECT=$(get_project_id_by_prefix "kubeflow")

cat <<EOF > "${GITHUB_WORKSPACE}/env/${GITHUB_USER}/.envrc-projects"
export IAM_PROJECT=${IAM_PROJECT}
export SECRET_PROJECT=${SECRET_PROJECT}
export NETWORK_PROJECT=${NETWORK_PROJECT}
export DATA_PROJECT=${DATA_PROJECT}
export COMPUTE_PROJECT=${COMPUTE_PROJECT}
export KUBEFLOW_PROJECT=${COMPUTE_PROJECT}
EOF
