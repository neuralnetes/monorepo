#!/bin/bash
if [[ -z "${TERRAGRUNT_WORKING_DIR}" ]]; then
  echo "TERRAGRUNT_WORKING_DIR must be set"
  exit 1
fi
if [[ -z "${TERRAGRUNT_COMMAND}" ]]; then
  echo "TERRAGRUNT_COMMAND must be set"
  exit 1
fi
if [[ "${SECRET}" == 'true' ]]; then
  terragrunt "${TERRAGRUNT_COMMAND}" \
    --terragrunt-include-dir "global/secret/**/**"
fi
if [[ "${IAM}" == 'true' ]]; then
  terragrunt "${TERRAGRUNT_COMMAND}" \
    --terragrunt-include-dir "global/iam/**/**"
fi
if [[ "${NETWORK}" == 'true' ]]; then
  terragrunt "${TERRAGRUNT_COMMAND}" \
    --terragrunt-include-dir "global/network/**/**" \
    --terragrunt-include-dir "us-central1/network/**/**"
fi
if [[ "${DATA}" == 'true' ]]; then
  terragrunt "${TERRAGRUNT_COMMAND}" \
    --terragrunt-include-dir "global/data/**/**" \
    --terragrunt-include-dir "us-central1/data/**/**"
fi
if [[ "${COMPUTE}" == 'true' ]]; then
  terragrunt "${TERRAGRUNT_COMMAND}" \
    --terragrunt-include-dir "global/compute/**/**" \
    --terragrunt-include-dir "us-central1/compute/**/**"
fi