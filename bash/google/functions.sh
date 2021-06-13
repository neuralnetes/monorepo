#!/bin/bash
function setup_gcloud() {
  if [[ -z "${HOME}/google-cloud-sdk" ]]; then
    exit 0
  fi
  GOOGLE_CLOUD_SDK_ARCHIVE=$1
  curl -s -O "https://dl.google.com/dl/cloudsdk/channels/rapid/downloads/${GOOGLE_CLOUD_SDK_ARCHIVE}"
  tar fxz "${GOOGLE_CLOUD_SDK_ARCHIVE}"
  rm -rf "${GOOGLE_CLOUD_SDK_ARCHIVE}"
  mv "google-cloud-sdk" "${HOME}"
  ln -fs "${HOME}/google-cloud-sdk/bin"/* "${HOME}/.local/bin"
  gcloud version
  gcloud components install -q beta alpha
}

function setup_gcloud_macos() {
  setup_gcloud "google-cloud-sdk-342.0.0-darwin-x86_64.tar.gz"
}

function setup_gcloud_linux() {
  setup_gcloud "google-cloud-sdk-342.0.0-linux-x86_64.tar.gz"
}

function get_project_id_by_prefix() {
  PROJECT_ID_PREFIX=$1
  PROJECTS=$2
  echo "${PROJECTS}" |
    jq -rc --arg project_id_prefix "${PROJECT_ID_PREFIX}" \
      '.[] | select(.projectId | startswith($project_id_prefix)) | .projectId'
}

function get_billing_account_id() {
  gcloud beta billing accounts list --format=json |
    jq -rc '[.[] | .name ] | sort | first'
}

function get_cluster() {
  gcloud container clusters list \
    --project="${KUBEFLOW_PROJECT}" \
    --format=json |
    jq 'first'
}

function get_cluster_name() {
  get_cluster |
    jq -rc '.name'
}

function get_kubeflow_project() {
  PROJECTS=$(get_projects)
  get_project_id_by_prefix "kubeflow" "${PROJECTS}"
}

function get_cluster_project() {
  get_kubeflow_project
}

function get_cluster_location() {
  get_cluster |
    jq -rc '.zone'
}

function get_network() {
  gcloud compute networks list \
    --project="${NETWORK_PROJECT}" \
    --format=json |
    jq 'first'
}

function get_network_name() {
  get_network |
    jq -rc '.name'
}

function get_network_self_link() {
  get_network |
    jq -rc '.selfLink'
}

function get_subnetwork() {
  gcloud compute networks subnets list \
    --project="${NETWORK_PROJECT}" \
    --format=json |
    jq 'first'
}

function get_subnetwork_name() {
  get_subnetwork |
    jq -rc '.name'
}

function get_subnetwork_self_link() {
  get_subnetwork |
    jq -rc '.selfLink'
}

function get_projects() {
  gcloud projects list --format=json
}

function get_compute_instance_by_name_prefix() {
  PREFIX=$1
  gcloud compute instances list --format=json \
    --project="${COMPUTE_PROJECT}" |
    jq --arg prefix "${PREFIX}" '.[] | select(.name | startswith($prefix)) | first'
}

function get_cluster_instance_groups() {
  gcloud compute instance-groups list \
    --project="${KUBEFLOW_PROJECT}" \
    --format=json |
    jq --arg cluster_name "${CLUSTER_NAME}" \
      '.[] | select(.name | contains($cluster_name))' |
    jq -s
}

function get_cluster_instance_group_self_links() {
  get_cluster_instance_groups |
    jq '.[] | .selfLink' |
    jq -s
}

function get_istio_ingressgateway_compute_address() {
  PREFIX="istio-ingressgateway"
  gcloud compute addresses list --format=json \
    --project="${KUBEFLOW_PROJECT}" |
    jq --arg prefix "${PREFIX}" '.[] | select(.name | startswith($prefix))'
}

function get_istio_ingressgateway_load_balancer_ip() {
  get_istio_ingressgateway_compute_address |
    jq -rc '.address'
}

function get_cluster_location() {
  get_cluster |
    jq -rc '.zone'
}

function get_dns_managed_zones() {
  gcloud dns managed-zones list \
    --project="${NETWORK_PROJECT}" \
    --format=json |
    jq
}

function get_dns_name_servers() {
  get_dns_managed_zones |
    jq '[.[] | .nameServers[]] | unique'
}

function get_artifact_registry_repository_id() {
  gcloud artifacts repositories list -q \
    --project="${ARTIFACT_PROJECT}" \
    --format=json |
    jq -rc 'first | .name | split("/") | last'
}

function get_artifact_registry_repository_location() {
  gcloud artifacts repositories list -q \
    --project="${ARTIFACT_PROJECT}" \
    --format=json |
    jq -rc 'first |  .name | split("/") | .[3]'
}

function get_artifact_registry_repository_host() {
  REPOSITORY_LOCATION=$(get_artifact_registry_repository_location)
  echo "${REPOSITORY_LOCATION}-docker.pkg.dev"
}

function get_artifact_registry_repository_url() {
  REPOSITORY_ID=$(get_artifact_registry_repository_id)
  REPOSITORY_LOCATION=$(get_artifact_registry_repository_location)
  echo "${REPOSITORY_LOCATION}-docker.pkg.dev/${ARTIFACT_PROJECT}/${REPOSITORY_ID}"
}

function get_container_cluster_credentials() {
  CLUSTER_NAME=$1
  CLUSTER_PROJECT=$2
  CLUSTER_LOCATION=$3
  gcloud container clusters get-credentials "${CLUSTER_NAME}" \
    --project="${CLUSTER_PROJECT}" \
    --zone="${CLUSTER_LOCATION}"
}

function get_service_projects() {
  SERVICE_PROJECTS=(
    "${ARTIFACT_PROJECT}"
    "${IAM_PROJECT}"
    "${SECRET_PROJECT}"
    "${DATA_PROJECT}"
    "${COMPUTE_PROJECT}"
    "${KUBEFLOW_PROJECT}"
  )
  echo "${SERVICE_PROJECTS[@]}"
}

function get_host_projects() {
  HOST_PROJECTS=(
    "${NETWORK_PROJECT}"
  )
  echo "${HOST_PROJECTS[@]}"
}

function get_host_project_lein() {
  HOST_PROJECT=$1
  gcloud alpha resource-manager liens list -q \
    --project="${HOST_PROJECT}" \
    --format=json \
    "${GCLOUD_FLAGS[@]}"
}

function get_resource_manager_lein_name() {
  HOST_PROJECT=$1
  get_host_project_lein "${HOST_PROJECT}" |
    jq -rc '[.[] | .name | split("/") | last] | first'
}

function resource_manager_liens_delete() {
  HOST_PROJECT=$1
  LIEN_NAME=$(get_resource_manager_lein_name "${HOST_PROJECT}")
  gcloud alpha resource-manager liens delete "${LIEN_NAME}" -q \
    --project="${HOST_PROJECT}" \
    "${GCLOUD_FLAGS[@]}"
}

function get_iam_role_included_permissions() {
  ROLE=$1
  gcloud iam roles describe "${ROLE}" --format=json |
    jq -rc '.includedPermissions[]'
}

function setup_kubectx() {
  CLUSTER_PROJECT="$(get_cluster_project)"
  CLUSTER_NAME="$(get_cluster_name)"
  CLUSTER_LOCATION="$(get_cluster_location)"
  gcloud container clusters get-credentials \
    --project="${CLUSTER_PROJECT}" \
    --zone="${CLUSTER_LOCATION}" \
    "${CLUSTER_NAME}"
}
