#!/bin/bash
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
    --role="${role}"
done

SERVICE_ACCOUNT_KEY="key.json"
gcloud iam service-accounts keys create "${SERVICE_ACCOUNT_KEY}" \
  --iam-account="${SERVICE_ACCOUNT_EMAIL}" \
  --project="${PROJECT}"

echo "store this secret in github secret"
cat "${SERVICE_ACCOUNT_KEY}"

TERRAFORM_GROUP_EMAIL="${SERVICE_ACCOUNT_NAME}@${ORGANIZATION}"
TERRAFORM_GROUP_ROLES=(
  "roles/iam.serviceAccountUser"
  "roles/iam.serviceAccountTokenCreator"
)
#ACCESS_TOKEN=$(gcloud auth print-access-token)
# TODO: automate creation of terraform google group via groups REST api
# https://www.googleapis.com/admin/directory/v1/groups
# https://cloud.google.com/identity/docs/reference/rest/v1/groups/create
# https://cloud.google.com/identity/docs/reference/rest/v1/groups.memberships/create
#echo "create google group ${TERRAFORM_GROUP_EMAIL}"
#curl --request POST \
#     --header "Content-Type: application/json" \
#     --header "Authorization: Bearer ${ACCESS_TOKEN}" \
#     --data '{"email":"${SERVICE_ACCOUNT_NAME}@${ORGANIZATION}","name":"terraform","description": "terraform"}'

for role in "${TERRAFORM_GROUP_ROLES[@]}"; do
  gcloud iam service-accounts add-iam-policy-binding "${SERVICE_ACCOUNT_EMAIL}" \
    --member="group:${TERRAFORM_GROUP_EMAIL}" \
    --role="${role}" \
    --project="${PROJECT}"
done
