locals {
  org             = get_env("GCP_ORGANIZATION")
  org_id          = get_env("GCP_ORGANIZATION_ID")
  billing_account = get_env("GCP_BILLING_ACCOUNT")
}