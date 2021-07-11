#!/bin/bash
function setup_gitconfig() {
  cat <<EOF >"${HOME}/.gitconfig"
[user]
  email = "${GITHUB_EMAIL}"
  name = "${GITHUB_NAME}"
  username = "${GITHUB_USERNAME}"
[core]
  editor = "${EDITOR}"
[init]
  defaultBranch = main
[pull]
  rebase = true
EOF
}

function setup_oh_my_zsh() {
  if [[ ! -d "${HOME}/.oh-my-zsh" ]]; then
    bash -c "$(wget https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh -O -)"
  fi
}

function setup_zshrc() {
  cat <<EOF >"${HOME}/.zshrc"
export ZSH="\${HOME}/.oh-my-zsh"
export ZSH_THEME="robbyrussell"
export plugins=(
    git
    fzf
    kubectl
)
export GITHUB_WORKSPACE="${GITHUB_WORKSPACE}"
export GITHUB_NAME="${GITHUB_NAME}"
export GITHUB_EMAIL="${GITHUB_EMAIL}"
export GITHUB_USERNAME="${GITHUB_USERNAME}"
source "\${ZSH}/oh-my-zsh.sh"
source "${GITHUB_WORKSPACE}/bash/workspace/${OS}-${ARCH}/.envrc-root"
eval "\$(pyenv init -)"
eval "\$(pyenv virtualenv-init -)"
EOF
}

function get_github_ref() {
  git branch --show-current "$(get_github_workspace)"
}

function get_github_sha() {
  git rev-parse HEAD "$(get_github_workspace)"
}

function get_github_sha_short() {
  git rev-parse --short HEAD "$(get_github_workspace)"
}

function get_git_config_global() {
  git config --global --list |
    cat
}

function get_github_name() {
  git config --global user.name
}

function get_github_email() {
  git config --global user.email
}

function get_github_username() {
  git config --global user.username
}

function get_github_workspace() {
  git rev-parse --show-toplevel
}

function get_github_repository() {
  git remote get-url origin |
    tr ":" "\n" |
    tail -n 1 |
    cut -d '.' -f 1
}

function get_github_owner() {
  get_github_repository |
    cut -d '/' -f 1
}

# https://docs.github.com/en/rest/reference/actions#list-repository-workflows
function get_github_workflows() {
  curl -s \
    -H "Accept: application/vnd.github.v3+json" \
    -H "Authorization: token ${GITHUB_TOKEN}" \
    "https://api.github.com/repos/${GITHUB_REPOSITORY}/actions/workflows" \
    | jq
}

# https://docs.github.com/en/rest/reference/actions#create-a-workflow-dispatch-event
function post_github_workflow_dispatch() {
  echo "${GITHUB_WORKFLOW_DISPATCH}"
  curl -s \
    -X POST \
    -H "Accept: application/vnd.github.v3+json" \
    -H "Authorization: token ${GITHUB_TOKEN}" \
    "https://api.github.com/repos/${GITHUB_REPOSITORY}/actions/workflows/${GITHUB_WORKFLOW_ID}/dispatches" \
    -d "${GITHUB_WORKFLOW_DISPATCH}"
}

# https://docs.github.com/en/rest/reference/actions#list-repository-workflows
function get_github_workflow_by_path() {
  get_github_workflows \
      | jq --arg path "${GITHUB_WORKFLOW_PATH}" \
        '.workflows[] | select(.path == $path)'
}

function post_github_workflow_dispatch_push_terragrunt() {
  GITHUB_WORKFLOW_DISPATCH=$(
    jq -n \
      --arg ref "${GITHUB_REF}" \
      '
        {
          "ref": $ref,
          "inputs": {}
        }
      '
  )
  GITHUB_WORKFLOW_PATH=".github/workflows/push-terragrunt.yaml"
  GITHUB_WORKFLOW=$(get_github_workflow_by_path)
  GITHUB_WORKFLOW_ID=$(echo "${GITHUB_WORKFLOW}" | jq '.id')
  post_github_workflow_dispatch
}

function post_github_workflow_dispatch_gcloud_projects_delete() {
  GITHUB_WORKFLOW_DISPATCH=$(
    jq -n \
      --arg ref "${GITHUB_REF}" \
      '
        {
          "ref": $ref,
          "inputs": {}
        }
      '
  )
  GITHUB_WORKFLOW_PATH=".github/workflows/workflow-dispatch-gcloud-projects-delete.yaml"
  GITHUB_WORKFLOW=$(get_github_workflow_by_path)
  GITHUB_WORKFLOW_ID=$(echo "${GITHUB_WORKFLOW}" | jq '.id')
  post_github_workflow_dispatch
}

function post_github_workflow_dispatch_generate_kubeflow_cluster() {
  GITHUB_WORKFLOW_DISPATCH=$(
    jq -n \
      --arg ref "${GITHUB_REF}" \
      --arg cluster_name "${CLUSTER_NAME}" \
      --arg cluster_location "${CLUSTER_LOCATION}" \
      --arg iam_project "${IAM_PROJECT}" \
      --arg dns_project "${DNS_PROJECT}" \
      --arg kubeflow_project "${KUBEFLOW_PROJECT}" \
      --arg network_project "${NETWORK_PROJECT}" \
      --arg secret_project "${SECRET_PROJECT}" \
      --arg istio_ingressgateway_load_balancer_ip "${ISTIO_INGRESSGATEWAY_LOAD_BALANCER_IP}" \
      '
        {
          "ref": $ref,
          "inputs": {
            "cluster_name": $cluster_name,
            "cluster_location": $cluster_location,
            "iam_project": $iam_project,
            "dns_project": $dns_project,
            "kubeflow_project": $kubeflow_project,
            "network_project": $network_project,
            "secret_project": $secret_project,
            "istio_ingressgateway_load_balancer_ip": $istio_ingressgateway_load_balancer_ip
          }
        }
      '
  )
  GITHUB_WORKFLOW_PATH=".github/workflows/workflow-dispatch-generate-kubeflow-cluster.yaml"
  GITHUB_WORKFLOW=$(get_github_workflow_by_path)
  GITHUB_WORKFLOW_ID=$(echo "${GITHUB_WORKFLOW}" | jq '.id')
  post_github_workflow_dispatch
}

function post_github_workflow_dispatch_generate_management_cluster() {
  GITHUB_WORKFLOW_DISPATCH=$(
    jq -n \
      --arg ref "${GITHUB_REF}" \
      --arg cluster_name "${CLUSTER_NAME}" \
      --arg cluster_location "${CLUSTER_LOCATION}" \
      --arg iam_project "${IAM_PROJECT}" \
      --arg dns_project "${DNS_PROJECT}" \
      --arg management_project "${MANAGEMENT_PROJECT}" \
      --arg network_project "${NETWORK_PROJECT}" \
      --arg secret_project "${SECRET_PROJECT}" \
      --arg istio_ingressgateway_load_balancer_ip "${ISTIO_INGRESSGATEWAY_LOAD_BALANCER_IP}" \
      '
        {
          "ref": $ref,
          "inputs": {
            "cluster_name": $cluster_name,
            "cluster_location": $cluster_location,
            "iam_project": $iam_project,
            "dns_project": $dns_project,
            "management_project": $management_project,
            "network_project": $network_project,
            "secret_project": $secret_project,
            "istio_ingressgateway_load_balancer_ip": $istio_ingressgateway_load_balancer_ip
          }
        }
      '
  )
  GITHUB_WORKFLOW_PATH=".github/workflows/workflow-dispatch-generate-management-cluster.yaml"
  GITHUB_WORKFLOW=$(get_github_workflow_by_path)
  GITHUB_WORKFLOW_ID=$(echo "${GITHUB_WORKFLOW}" | jq '.id')
  post_github_workflow_dispatch
}

function post_github_workflow_dispatch_kustomize_build_kubectl_apply() {
  GITHUB_WORKFLOW_DISPATCH=$(
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
  GITHUB_WORKFLOW_PATH=".github/workflows/workflow-dispatch-kustomize-build-kubectl-apply.yaml"
  GITHUB_WORKFLOW=$(get_github_workflow_by_path)
  GITHUB_WORKFLOW_ID=$(echo "${GITHUB_WORKFLOW}" | jq '.id')
  post_github_workflow_dispatch
}

function post_github_workflow_dispatch_terragrunt() {
  GITHUB_WORKFLOW_DISPATCH=$(
    jq -n \
      --arg ref "${GITHUB_REF}" \
      --arg terragrunt_working_dir "${TERRAGRUNT_WORKING_DIR}" \
      --arg terragrunt_command "${TERRAGRUNT_COMMAND}" \
      --arg terragrunt_cli_flags "${TERRAGRUNT_CLI_FLAGS[*]}" \
      '
        {
          "ref": $ref,
          "inputs": {
            "terragrunt_working_dir": $terragrunt_working_dir,
            "terragrunt_command": $terragrunt_command,
            "terragrunt_cli_flags": $terragrunt_cli_flags
          }
        }
      '
  )
  GITHUB_WORKFLOW_PATH=".github/workflows/workflow-dispatch-terragrunt.yaml"
  GITHUB_WORKFLOW=$(get_github_workflow_by_path)
  GITHUB_WORKFLOW_ID=$(echo "${GITHUB_WORKFLOW}" | jq '.id')
  post_github_workflow_dispatch
}

function post_github_workflow_dispatch_terragrunt_shared() {
  TERRAGRUNT_CLI_FLAGS=($(get_terragrunt_cli_flags_shared))
  TERRAGRUNT_WORKING_DIR=$(get_terragrunt_working_dir_shared)
  TERRAGRUNT_COMMAND="run-all apply"
  post_github_workflow_dispatch_terragrunt
}

function post_github_workflow_dispatch_terragrunt_non_prod() {
  TERRAGRUNT_CLI_FLAGS=($(get_terragrunt_cli_flags_non_prod))
  TERRAGRUNT_WORKING_DIR=$(get_terragrunt_working_dir_non_prod)
  TERRAGRUNT_COMMAND="run-all apply"
  post_github_workflow_dispatch_terragrunt
}

function post_slack_event() {
    STATUS=$1
    TEXT=$(
      jq -n \
        --arg run "${GITHUB_ACTIONS_RUN_URL}" \
        --arg status "${STATUS}" \
        '{
          "type": "github_actions",
          "data": {
            "status": $status,
            "run": $run
          }
        }'
    )
    export SLACK_WEBHOOK_DATA=$(
      jq -n \
        --argjson text "${TEXT}" \
        '{
          "text": ($text | tostring)
        }'
    )
    post_slack_webhook
}

function post_slack_webhook() {
  curl -X POST -H 'Content-type: application/json' \
    --data "${SLACK_WEBHOOK_DATA}" \
    "${SLACK_WEBHOOK}"
}
