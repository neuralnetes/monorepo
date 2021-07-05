#!/bin/bash
function setup_gcloud() {
  if [[ ! -d "${HOME}/google-cloud-sdk" ]]; then
    VERSION=344.0.0
    GOOGLE_CLOUD_SDK_ARCHIVE="google-cloud-sdk-${VERSION}-${OS}-x86_64.tar.gz"
    curl -s -O "https://dl.google.com/dl/cloudsdk/channels/rapid/downloads/${GOOGLE_CLOUD_SDK_ARCHIVE}"
    tar fxz "${GOOGLE_CLOUD_SDK_ARCHIVE}"
    rm -rf "${GOOGLE_CLOUD_SDK_ARCHIVE}"
    mv "google-cloud-sdk" "${HOME}"
    ln -fs "${HOME}/google-cloud-sdk/bin"/* "${HOME}/.local/bin"
    gcloud version
    gcloud components install -q beta alpha
  fi
}

function get_container_cluster_credentials() {
  if [[ -z "${CLUSTER_PROJECT}" ]]; then
    CLUSTER_PROJECT="$(get_cluster_project)"
  fi
  if [[ -z "${CLUSTER_NAME}" ]]; then
    CLUSTER_NAME="$(get_cluster_name)"
  fi
  if [[ -z "${CLUSTER_LOCATION}" ]]; then
    CLUSTER_LOCATION="$(get_cluster_location)"
  fi
  if [[ -z "${GCLOUD_FLAGS}" ]]; then
    GCLOUD_FLAGS=()
  fi
  gcloud container clusters get-credentials \
    "${CLUSTER_NAME}" \
    --project="${CLUSTER_PROJECT}" \
    --zone="${CLUSTER_LOCATION}" \
    "${GCLOUD_FLAGS[@]}"
}

function get_impersonate_service_account() {
  echo "terraform@terraform-neuralnetes.iam.gserviceaccount.com"
}

function get_gcloud_flags() {
  GCLOUD_FLAGS=(
    "-q"
    "--format=json"
    "--impersonate-service-account=$(get_impersonate_service_account)"
  )
  echo "${GCLOUD_FLAGS[@]}"
}

function get_organization() {
  gcloud organizations list \
    --format=json \
    "${GCLOUD_FLAGS[@]}" \
    | jq 'first'
}

function get_organization_display_name() {
  get_organization \
    | jq -rc '.displayName'
}

function get_organization_id() {
  get_organization \
    | jq -rc '.name | split("/") | last'
}

function get_gcp_workspace_customer_id() {
  get_organization \
    | jq -rc '.owner.directoryCustomerId'
}

function get_gcp_workspace_domain_name() {
  get_organization_display_name
}

function get_gcs_terraform_remote_state_bucket() {
  echo "terraform-neuralnetes"
}

function get_gcs_terraform_remote_state_location() {
  echo "US"
}

function get_project_id_by_prefix() {
  PREFIX=$1
  get_projects |
    jq -rc --arg prefix "${PREFIX}" \
    '.[] | select(.projectId | startswith($prefix)) | .projectId'
}

function get_organizations() {
  gcloud organizations list "${GCLOUD_FLAGS[@]}"
}

function get_billing_account_id() {
  gcloud beta billing accounts list \
    "${GCLOUD_FLAGS[@]}" \
    | jq 'first | .name'
}

function get_cluster() {
  gcloud container clusters list \
    --project="${KUBEFLOW_PROJECT}" \
    --format=json \
    "${GCLOUD_FLAGS[@]}" |
    jq 'first'
}

function get_cluster_name() {
  get_cluster |
    jq -rc '.name'
}

function get_projects() {
 gcloud projects list --format=json \
    "${GCLOUD_FLAGS[@]}" \
    | jq
}

function get_terraform_project() {
  get_project_id_by_prefix "terraform"
}

function get_dns_project() {
  get_project_id_by_prefix "dns"
}

function get_iam_project() {
  get_project_id_by_prefix "iam"
}

function get_network_project() {
  get_project_id_by_prefix "network"
}

function get_secret_project() {
  get_project_id_by_prefix "secret"
}

function get_kubeflow_project() {
  get_project_id_by_prefix "kubeflow"
}

function get_compute_project() {
  get_project_id_by_prefix "compute"
}

function get_data_project() {
  get_project_id_by_prefix "data"
}

function get_artifact_project() {
  get_project_id_by_prefix "artifact"
}

function get_cluster_project() {
  get_kubeflow_project
}

function get_cluster_location() {
  get_cluster \
    | jq -rc '.zone'
}

function get_network() {
  gcloud compute networks list \
    --project="${NETWORK_PROJECT}" \
    --format=json \
    "${GCLOUD_FLAGS[@]}" \
    | jq 'first'
}

function get_network_name() {
  get_network \
    | jq -rc '.name'
}

function get_network_self_link() {
  get_network \
    | jq -rc '.selfLink'
}

function get_subnetwork() {
  gcloud compute networks subnets list \
    --project="${NETWORK_PROJECT}" \
    --format=json \
    "${GCLOUD_FLAGS[@]}" \
    | jq 'first'
}

function get_subnetwork_name() {
  get_subnetwork \
    | jq -rc '.name'
}

function get_subnetwork_self_link() {
  get_subnetwork \
    | jq -rc '.selfLink'
}

function get_compute_instance_by_name_prefix() {
  PREFIX=$1
  gcloud compute instances list --format=json \
    --project="${COMPUTE_PROJECT}" \
    --format=json \
    "${GCLOUD_FLAGS[@]}" \
    | jq --arg prefix "${PREFIX}" '.[] | select(.name | startswith($prefix)) | first'
}

function get_cluster_instance_groups() {
  gcloud compute instance-groups list \
    --project="${KUBEFLOW_PROJECT}" \
    --format=json \
    "${GCLOUD_FLAGS[@]}" \
    | jq --arg cluster_name "${CLUSTER_NAME}" '[.[] | select(.name | contains($cluster_name))]'
}

function get_cluster_instance_group_self_links() {
  get_cluster_instance_groups \
    | jq '[.[] | .selfLink]'
}

function get_istio_ingressgateway_compute_address() {
  PREFIX="istio-ingressgateway"
  gcloud compute addresses list \
    --format=json \
    --project="${KUBEFLOW_PROJECT}" \
    "${GCLOUD_FLAGS[@]}" \
    | jq --arg prefix "${PREFIX}" '.[] | select(.name | startswith($prefix))'
}

function get_istio_ingressgateway_load_balancer_ip() {
  get_istio_ingressgateway_compute_address \
    | jq -rc '.address'
}

function get_cluster_location() {
  get_cluster \
    | jq -rc '.zone'
}

function get_latest_valid_cluster_master_version() {
  gcloud container get-server-config --zone="${CLUSTER_LOCATION}" --format=json --project="${CLUSTER_PROJECT}" \
    | jq -rc '.validMasterVersions | sort | last'
}

function get_dns_managed_zones() {
  gcloud dns managed-zones list \
    --project="${DNS_PROJECT}" \
    --format=json \
    "${GCLOUD_FLAGS[@]}" \
    | jq
}

function get_dns_name_servers() {
  get_dns_managed_zones \
    | jq '[.[] | .nameServers[]] | unique'
}

function get_artifact_registry_repository() {
  gcloud artifacts repositories list -q \
    --project="${ARTIFACT_PROJECT}" \
    --format=json \
    "${GCLOUD_FLAGS[@]}"
}

function get_artifact_registry_repository_id() {
  echo "${ARTIFACT_REGISTRY_REPOSITORY}" \
    | jq -rc 'first | .name | split("/") | last'
}

function get_artifact_registry_repository_location() {
  echo "${ARTIFACT_REGISTRY_REPOSITORY}" \
    | jq -rc 'first |  .name | split("/") | .[3]'
}

function get_artifact_registry_repository_host() {
  echo "${ARTIFACT_REGISTRY_REPOSITORY_LOCATION}-docker.pkg.dev"
}

function get_artifact_registry_repository_url() {
  echo "${ARTIFACT_REGISTRY_REPOSITORY_HOST}/${ARTIFACT_PROJECT}/${REPOSITORY_ID}"
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
  get_host_project_lein "${HOST_PROJECT}" \
    | jq -rc '[.[] | .name | split("/") | last] | first'
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
  gcloud iam roles describe "${ROLE}" --format=json \
    | jq -rc '.includedPermissions[]'
}

function is_project_id() {
  PROJECT_ID=$1
  gcloud projects list --format=json "${GCLOUD_FLAGS[@]}" \
    | jq -rc --arg project_id "${PROJECT_ID}" '[.[] | select(.name == $project_id)] | length == 1'
}

function projects_delete() {
  SERVICE_PROJECTS=($(get_service_projects))
  for project_id in "${SERVICE_PROJECTS[@]}"; do
    if [[ "$(is_project_id "${project_id}")" == "true" ]]; then
      gcloud projects delete "${project_id}" -q "${GCLOUD_FLAGS[@]}"
      project_prefix=$(echo "${project_id}" | cut -d- -f1)
      if [[ -n "${IMPERSONATE_SERVICE_ACCOUNT}" ]]; then
        gsutil -i "${IMPERSONATE_SERVICE_ACCOUNT}" -m rm -rf "gs://terraform-neuralnetes/non-prod/global/${project_prefix}"
        gsutil -i "${IMPERSONATE_SERVICE_ACCOUNT}" -m rm -rf "gs://terraform-neuralnetes/non-prod/us-central1/${project_prefix}"
      else
        gsutil -m rm -rf "gs://${GCS_TERRAFORM_REMOTE_STATE_BUCKET}/non-prod/global/${project_prefix}"
        gsutil -m rm -rf "gs://${GCS_TERRAFORM_REMOTE_STATE_BUCKET}/non-prod/us-central1/${project_prefix}"
      fi
    fi
  done

  HOST_PROJECTS=($(get_host_projects))
  for project_id in "${HOST_PROJECTS[@]}"; do
    if [[ "$(is_project_id "${project_id}")" == "true" ]]; then
      resource_manager_liens_delete "${project_id}"
      gcloud projects delete "${project_id}" -q "${GCLOUD_FLAGS[@]}"
      project_prefix=$(echo "${project_id}" | cut -d- -f1)
      if [[ -n "${IMPERSONATE_SERVICE_ACCOUNT}" ]]; then
        gsutil -i "${IMPERSONATE_SERVICE_ACCOUNT}" -m rm -rf "gs://terraform-neuralnetes/non-prod/global/${project_prefix}"
        gsutil -i "${IMPERSONATE_SERVICE_ACCOUNT}" -m rm -rf "gs://terraform-neuralnetes/non-prod/us-central1/${project_prefix}"
      else
        gsutil -m rm -rf "gs://${GCS_TERRAFORM_REMOTE_STATE_BUCKET}/non-prod/global/${project_prefix}"
        gsutil -m rm -rf "gs://${GCS_TERRAFORM_REMOTE_STATE_BUCKET}/non-prod/us-central1/${project_prefix}"
      fi
    fi
  done

  gsutil -i "${IMPERSONATE_SERVICE_ACCOUNT}" -m rm -rf  'gs://terraform-neuralnetes/shared/global/shared/**/*'
}

function organization_bootstrap() {
  ORGANIZATION="neuralnetes.com"
  ORGANIZATION_IAM_ROLES=(
    "roles/billing.admin"
    "roles/compute.admin"
    "roles/container.admin"
    "roles/iam.organizationRoleAdmin"
    "roles/iam.serviceAccountAdmin"
    "roles/iam.serviceAccountKeyAdmin"
    "roles/iam.serviceAccountTokenCreator"
    "roles/iam.serviceAccountUser"
    "roles/identityplatform.admin"
    "roles/identitytoolkit.admin"
    "roles/resourcemanager.folderAdmin"
    "roles/resourcemanager.organizationAdmin"
    "roles/resourcemanager.projectCreator"
    "roles/serviceusage.serviceUsageAdmin"
    "roles/storage.admin"
  )
  PROJECT="terraform-neuralnetes"
  SERVICE_ACCOUNT_NAME="terraform"
  SERVICE_ACCOUNT_EMAIL="${SERVICE_ACCOUNT_NAME}@${PROJECT}.iam.gserviceaccount.com"

  echo "log in with super administrator google account"
  gcloud auth login

  ORGANIZATION_ID=$(
    gcloud organizations list --format=json |
      jq -rc --arg display_name "${ORGANIZATION}" \
        '.[] | select(.displayName == $display_name) | .name | split("/") | last'
  )

  gcloud projects create "${PROJECT}"

  PROJECT_SERVICES=(
    "admin.googleapis.com"
    "bigquery.googleapis.com"
    "bigquerystorage.googleapis.com"
    "cloudbilling.googleapis.com"
    "cloudresourcemanager.googleapis.com"
    "cloudtrace.googleapis.com"
    "compute.googleapis.com"
    "container.googleapis.com"
    "containerregistry.googleapis.com"
    "deploymentmanager.googleapis.com"
    "iam.googleapis.com"
    "iamcredentials.googleapis.com"
    "logging.googleapis.com"
    "monitoring.googleapis.com"
    "oslogin.googleapis.com"
    "pubsub.googleapis.com"
    "servicemanagement.googleapis.com"
    "servicenetworking.googleapis.com"
    "serviceusage.googleapis.com"
    "sqladmin.googleapis.com"
    "storage-api.googleapis.com"
    "storage.googleapis.com"
  )

  for project_service in "${PROJECT_SERVICES[@]}"; do
    echo "enabling ${project_service}"
    gcloud services enable "${project_service}" \
      --project="${PROJECT}"
  done

  gcloud iam service-accounts create "${SERVICE_ACCOUNT_NAME}" \
    --description="${SERVICE_ACCOUNT_NAME}" \
    --display-name="${SERVICE_ACCOUNT_NAME}" \
    --project="${PROJECT}"

  for role in "${ORGANIZATION_IAM_ROLES[@]}"; do
    gcloud organizations add-iam-policy-binding "${ORGANIZATION_ID}" \
      --member="serviceAccount:${SERVICE_ACCOUNT_EMAIL}" \
      --role="${role}" \
      "${GCLOUD_FLAGS[@]}"
  done

  SERVICE_ACCOUNT_KEY="key.json"
  gcloud iam service-accounts keys create "${SERVICE_ACCOUNT_KEY}" \
    --iam-account="${SERVICE_ACCOUNT_EMAIL}" \
    --project="${PROJECT}" \
    "${GCLOUD_FLAGS[@]}"

  echo "store this secret in github secret"
  echo "${SERVICE_ACCOUNT_KEY}"
  cat "${SERVICE_ACCOUNT_KEY}"
}

function watch_dns() {
  url="https://dns.google/resolve?name=kubeflow.non-prod.${GCP_WORKSPACE_DOMAIN_NAME}&type=A"
  command="curl -s '${url}' | jq '.Answer'"
  watch -d -n 2 "${command}"
}
