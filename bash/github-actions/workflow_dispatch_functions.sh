#!/bin/bash
cd "$(dirname "$0")"
workflow=$(./find_workflow_by_path.sh ".github/workflows/gcs-source-archive-bucket-upload.yaml")
workflow_id=$(echo "${workflow}" | jq '.id')
./workflow_dispatch.sh "${workflow_id}" '{ "ref": "'"${GITHUB_REF}"'"}'
