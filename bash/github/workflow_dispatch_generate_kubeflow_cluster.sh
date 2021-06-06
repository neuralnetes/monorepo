#!/bin/bash
request_json=$(
  jq -n \
    --arg ref "${GITHUB_REF}" \
    --arg cluster_name "${CLUSTER_NAME}" \
    --arg cluster_location "${CLUSTER_LOCATION}" \
    --arg compute_project "${COMPUTE_PROJECT}" \
    --arg iam_project "${IAM_PROJECT}" \
    --arg kubeflow_project "${KUBEFLOW_PROJECT}" \
    --arg network_project "${NETWORK_PROJECT}" \
    --arg secret_project "${SECRET_PROJECT}" \
    '
      {
        "ref": $ref,
        "inputs": {
          "cluster_name": $cluster_name,
          "compute_project": $compute_project,
          "cluster_location": $cluster_location,
          "iam_project": $iam_project,
          "kubeflow_project": $kubeflow_project,
          "network_project": $network_project,
          "secret_project": $secret_project
        }
      }
    '
)
echo "${request_json}" | jq
workflow=$(bash "${GITHUB_WORKSPACE}/bash/github/find_workflow_by_path.sh"  ".github/workflows/workflow-dispatch-generate-kubeflow-cluster.yaml")
workflow_id=$(echo "${workflow}" | jq '.id')
bash "${GITHUB_WORKSPACE}/bash/github/workflow_dispatch.sh" "${workflow_id}" "${request_json}"