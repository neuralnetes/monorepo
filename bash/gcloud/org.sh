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
SERVICE_ACCOUNT_KEY="key.json"
SERVICE_ACCOUNT_NAME="terraform"
SERVICE_ACCOUNT_EMAIL="terraform@${ROOT_PROJECT}.iam.gserviceaccount.com"
GROUP_EMAIL="${SERVICE_ACCOUNT_NAME}@${ORGANIZATION}"


# TODO: create terraform google group
gcloud projects create "${ROOT_PROJECT}"
gcloud iam service-accounts create "${SERVICE_ACCOUNT_NAME}" \
  --description="${SERVICE_ACCOUNT_NAME}" \
  --display-name="${SERVICE_ACCOUNT_NAME}" \
  --project="${ROOT_PROJECT}"

gcloud iam service-accounts keys create "${SERVICE_ACCOUNT_KEY}" \
  --iam-account="${SERVICE_ACCOUNT_EMAIL}" \
  --project="${ROOT_PROJECT}"

# TODO: cat key.json | pbcopy upload to github actions secret

for role in "${ORGANIZATION_IAM_ROLES[@]}"; do
  gcloud organizations add-iam-policy-binding "${ORGANIZATION}" \
    --member="group:${GROUP_EMAIL}" \
    --role="${role}"
done

# USER_GROUP_EMAIL="${SERVICE_ACCOUNT_NAME}-users@${ORGANIZATION}"
#SERVICE_ACCOUNT_USERS=(
#  "alexander.lerma@${ORGANIZATION}"
#)
#gcloud iam service-accounts add-iam-policy-binding \
#  "${SERVICE_ACCOUNT_EMAIL}" \
#  --member="group:${USER_GROUP_EMAIL}" \
#  --role="roles/iam.serviceAccountUser"
#
#for service_account_user in "${SERVICE_ACCOUNT_USERS[@]}"; do
#  # TODO: add users to terraform-users@neuralnetes.com group
#  echo "add ${service_account_user} to ${USER_GROUP_EMAIL}"
#done