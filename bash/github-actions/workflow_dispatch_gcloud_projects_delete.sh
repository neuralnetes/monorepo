#!/bin/bash
request_json=$(
  jq -n \
    --arg ref "${GITHUB_REF}" \
    --arg compute_project "${COMPUTE_PROJECT}" \
    --arg data_project "${DATA_PROJECT}" \
    --arg iam_project "${IAM_PROJECT}" \
    --arg kubeflow_project "${KUBEFLOW_PROJECT}" \
    --arg network_project "${NETWORK_PROJECT}" \
    --arg secret_project "${SECRET_PROJECT}" \
    '
      {
        "ref": $ref,
        "inputs": {
          "compute_project": $compute_project,
          "data_project": $data_project,
          "iam_project": $iam_project,
          "kubeflow_project": $kubeflow_project,
          "network_project": $network_project,
          "secret_project": $secret_project
        }
      }
    '
)
echo "${request_json}" | jq
workflow=$(bash "${GITHUB_WORKSPACE}/bash/github-actions/find_workflow_by_path.sh"  ".github/workflows/workflow-dispatch-gcloud-projects-delete.yaml")
workflow_id=$(echo "${workflow}" | jq '.id')
bash "${GITHUB_WORKSPACE}/bash/github-actions/workflow_dispatch.sh" "${workflow_id}" "${request_json}"
