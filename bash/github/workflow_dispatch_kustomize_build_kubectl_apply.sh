#!/bin/bash
request_json=$(
  jq -n \
    --arg ref "${GITHUB_REF}" \
    --arg cluster_name "${CLUSTER_NAME}" \
    --arg cluster_location "${CLUSTER_LOCATION}" \
    --arg cluster_project "${CLUSTER_PROJECT}" \
    '
      {
        "ref": $ref,
        "inputs": {
          "cluster_name": $cluster_name,
          "cluster_location": $cluster_location,
          "cluster_project": $cluster_project
        }
      }
    '
)
echo "${request_json}" | jq
workflow=$(bash "${GITHUB_WORKSPACE}/bash/github/find_workflow_by_path.sh"  ".github/workflows/workflow-dispatch-kustomize-build-kubectl-apply.yaml")
workflow_id=$(echo "${workflow}" | jq '.id')
bash "${GITHUB_WORKSPACE}/bash/github/workflow_dispatch.sh" "${workflow_id}" "${request_json}"
