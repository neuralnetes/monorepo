#!/bin/bash
function setup_tgenv() {
  TGENV_ROOT="${HOME}/.tgenv"
  if [[ ! -d "${TGENV_ROOT}" ]]; then
    git clone https://github.com/cunymatthieu/tgenv.git "${TGENV_ROOT}"
    ln -fs "${TGENV_ROOT}/bin"/* "${HOME}/.local/bin"
    tgenv install
  fi
}

function update_terragrunt_version() {
  tgenv list-remote |
    head -n 1 \
      >"${GITHUB_WORKSPACE}/.terragrunt-version"
}

function terragrunt_non_prod() {
  TERRAGRUNT_CLI_FLAGS=(
    "--terragrunt-working-dir terragrunt/live/gcs/non-prod"
    "--terragrunt-include-dir global/terraform/**/**"
    "--terragrunt-include-dir global/dns/**/**"
    "--terragrunt-include-dir global/iam/**/**"
    "--terragrunt-include-dir global/secret/**/**"
    "--terragrunt-include-dir global/artifact/**/**"
    "--terragrunt-include-dir global/network/**/**"
    "--terragrunt-include-dir global/data/**/**"
    "--terragrunt-include-dir global/compute/**/**"
    "--terragrunt-include-dir global/kubeflow/**/**"
    "--terragrunt-include-dir us-central1/network/**/**"
    "--terragrunt-include-dir us-central1/data/**/**"
    "--terragrunt-include-dir us-central1/compute/**/**"
    "--terragrunt-include-dir us-central1/kubeflow/**/**"
  )
  terragrunt "${TERRAGRUNT_COMMAND}" "${TERRAGRUNT_CLI_FLAGS[@]}"
}

function terragrunt_non_prod_run_all_apply() {
  TERRAGRUNT_COMMAND='run-all apply'
  terragrunt_non_prod
}

function terragrunt_non_prod_run_all_plan() {
  TERRAGRUNT_COMMAND='run-all plan'
  terragrunt_non_prod
}

function terragrunt_non_prod_run_all_output() {
  TERRAGRUNT_COMMAND='run-all output'
  terragrunt_non_prod
}
