function setup_gitconfig() {
  cat <<EOF >"${HOME}/.gitconfig"
[user]
  email = ${GITHUB_EMAIL}
  name = ${GITHUB_NAME}
  username = ${GITHUB_USERNAME}
[core]
  editor = \$EDITOR
[init]
  defaultBranch = main
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
    gcloud
)
export GITHUB_WORKSPACE=$(get_github_workspace)
export GITHUB_USER=$(get_github_username)
source "\${ZSH}/oh-my-zsh.sh"
source "\${GITHUB_WORKSPACE}/workspace/base/functions.sh"
source "\${GITHUB_WORKSPACE}/workspace/base/.envrc"
source "\${GITHUB_WORKSPACE}/workspace/\${GITHUB_USER}/.envrc"
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

function get_github_username_workspace() {
  GITHUB_WORKSPACE=$(get_github_workspace)
  GITHUB_USERNAME=$(get_github_username)
  echo "${GITHUB_WORKSPACE}/workspace/${GITHUB_USERNAME}"
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

function post_github_workflow_dispatch_gcloud_projects_delete() {
  GITHUB_WORKFLOW_DISPATCH=$(
    jq -n \
      --arg ref "${GITHUB_REF}" \
      --arg artifact_project "${ARTIFACT_PROJECT}" \
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
            "artifact_project": $artifact_project,
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
      --arg compute_project "${COMPUTE_PROJECT}" \
      --arg iam_project "${IAM_PROJECT}" \
      --arg dns_project "${DNS_PROJECT}" \
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
            "dns_project": $dns_project,
            "kubeflow_project": $kubeflow_project,
            "network_project": $network_project,
            "secret_project": $secret_project
          }
        }
      '
  )
  GITHUB_WORKFLOW_PATH=".github/workflows/workflow-dispatch-generate-kubeflow-cluster.yaml"
  GITHUB_WORKFLOW=$(get_github_workflow_by_path)
  GITHUB_WORKFLOW_ID=$(echo "${GITHUB_WORKFLOW}" | jq '.id')
  post_github_workflow_dispatch
}

function post_github_workflow_dispatch_generate_kustomize_build_kubectl_apply() {
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

function post_github_workflow_dispatch_terragrunt_non_prod() {
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
  TERRAGRUNT_WORKING_DIR="terragrunt/live/gcs/non-prod"
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

function debug_slack_event() {
  EVENT=$1
  EVENT_DATA_RUN=$(echo "${EVENT}" | jq -rc '.data.run')
  EVENT_DATA_LOGS=$(echo "${EVENT}" | jq -rc '.data.logs')
  EVENT_DATA_ENV=$(echo "${EVENT}" | jq -rc '.data.env')
  GITHUB_USERNAME_WORKSPACE=$(get_github_username_workspace)
  echo "${EVENT_DATA_RUN}"
  gsutil cp "${EVENT_DATA_LOGS}" "${GITHUB_USERNAME_WORKSPACE}/logs.txt"
  gsutil cp "${EVENT_DATA_ENV}" "${GITHUB_USERNAME_WORKSPACE}/env.txt"
  cat "${GITHUB_USERNAME_WORKSPACE}/logs.txt" \
    | jq -s '.[] | select(.["@message"] | contains("error")) | .["@message"]'
  cat "${GITHUB_USERNAME_WORKSPACE}/env.txt"
}