locals {
  org             = get_env("GCP_ORG")
  org_id          = get_env("GCP_ORG_ID")
  billing_account = get_env("GCP_BILLING_ACCOUNT")
}