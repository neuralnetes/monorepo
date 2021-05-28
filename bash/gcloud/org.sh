#!/bin/bash
ORGANIZATION="neuralnetes.com"
ORGANIZATION_IAM_ROLES=(
  "roles/billing.admin"
  "roles/compute.admin"
  "roles/container.admin"
  "roles/resourcemanager.folderAdmin"
  "roles/resourcemanager.organizationAdmin"
  "roles/resourcemanager.projectCreator"
  "roles/serviceusage.serviceUsageAdmin"
  "roles/storage.admin"
)
ROOT_PROJECT="terraform-neuralnetes"
SERVICE_ACCOUNT_NAME="terraform"
SERVICE_ACCOUNT_EMAIL="terraform@${ROOT_PROJECT}.iam.gserviceaccount.com"
SERVICE_ACCOUNT_USERS=(
  "alexander.lerma@${ORGANIZATION}"
)
GROUP_EMAIL="${SERVICE_ACCOUNT_NAME}@${ORGANIZATION}"
USER_GROUP_EMAIL="${SERVICE_ACCOUNT_NAME}-users@${ORGANIZATION}"

gcloud projects create "${ROOT_PROJECT}"
gcloud iam service-accounts create "${SERVICE_ACCOUNT_NAME}" \
  --description="${SERVICE_ACCOUNT_NAME}" \
  --display-name="${SERVICE_ACCOUNT_NAME}" \
  --project="${ROOT_PROJECT}"

gcloud iam service-accounts add-iam-policy-binding \
  "${SERVICE_ACCOUNT_EMAIL}" \
  --member="group:${USER_GROUP_EMAIL}" \
  --role="roles/iam.serviceAccountUser"

for role in "${ORGANIZATION_IAM_ROLES[@]}"; do
  gcloud organizations add-iam-policy-binding "${ORGANIZATION}" \
    --member="group:${GROUP_EMAIL}" \
    --role="${role}"
done

for service_account_user in "${SERVICE_ACCOUNT_USERS[@]}"; do
  # TODO: add users to terraform-users@neuralnetes.com group
  echo "add ${service_account_user} to ${USER_GROUP_EMAIL}"
done
