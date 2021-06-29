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

function get_terragrunt_working_dir() {
  echo "${GITHUB_WORKSPACE}/terragrunt/live/gcs/non-prod"
}

function get_terragrunt_cli_flags() {
  if [[ -z "${TERRAGRUNT_WORKING_DIR}" ]]; then
    TERRAGRUNT_WORKING_DIR=$(get_terragrunt_working_dir)
  fi
  TERRAGRUNT_CLI_FLAGS=(
    "--terragrunt-working-dir ${TERRAGRUNT_WORKING_DIR}"
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
  echo "${TERRAGRUNT_CLI_FLAGS[@]}"
}

function run_terragrunt() {
  if [[ -z "${TERRAGRUNT_COMMAND}" ]]; then
    echo "TERRAGRUNT_COMMAND string is empty"
    exit 1
  fi
  if [[ -z "${TERRAGRUNT_CLI_FLAGS}" ]]; then
    echo "TERRAGRUNT_CLI_FLAGS array is empty"
    exit 1
  fi
  terragrunt "${TERRAGRUNT_COMMAND}" "${TERRAGRUNT_CLI_FLAGS[@]}"
}

function terragrunt_hclfmt() {
  TERRAGRUNT_COMMAND='hclfmt'
  TERRAGRUNT_CLI_FLAGS=($(get_terragrunt_cli_flags))
  run_terragrunt
}

function terragrunt_run_all_apply() {
  TERRAGRUNT_COMMAND='run-all apply'
  TERRAGRUNT_CLI_FLAGS=($(get_terragrunt_cli_flags))
  run_terragrunt
}

function terragrunt_run_all_plan() {
  TERRAGRUNT_COMMAND='run-all plan'
  TERRAGRUNT_CLI_FLAGS=($(get_terragrunt_cli_flags))
  run_terragrunt
}

function terragrunt_run_all_output() {
  TERRAGRUNT_COMMAND='run-all output'
  TERRAGRUNT_CLI_FLAGS=($(get_terragrunt_cli_flags))
  run_terragrunt
}
