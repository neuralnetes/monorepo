#!/bin/bash
cd "$(dirname "$0")"
REQUIRED_API_SERVICES=(
  "secretmanager.googleapis.com"
)
SECRET_JSON=$(cat <<-EOF
  {
    "GOOGLE_APPLICATION_CREDENTIALS": "",
    "GCP_BILLING_ACCOUNT": "",
    "GCP_ORG": "",
    "GCP_ORG_ID": "",
    "GCP_PROJECT_ID": "terraform-neuralnetes-admin-ec",
    "GCS_TERRAFORM_REMOTE_STATE_BUCKET": "terraform-neuralnetes-admin-ec-state",
    "GCS_TERRAFORM_REMOTE_STATE_LOCATION": "US",
    "GH_ORGANIZATION_NAME": "neuralnetes",
    "GH_ORGANIZATION_TOKEN": "",
    "GH_ORGANIZATION_USER": "",
    "DD_API_KEY": "",
    "DD_API_KEY": "",
    "TF_INPUT": "",
    "TF_PROVIDER_KUBERNETES_VERSION": ""
  }
EOF
)