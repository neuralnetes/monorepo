terraform {
  source = "github.com/neuralnetes/monorepo.git//terraform/modules/google/identity-groups?ref=main"
}

include {
  path = find_in_parent_folders()
}

locals {
  gcp_workspace_customer_id = get_env("GCP_WORKSPACE_CUSTOMER_ID")
  gcp_workspace_domain_name = get_env("GCP_WORKSPACE_DOMAIN_NAME")
}

inputs = {
  identity_groups = [
    for display_name in ["kubeflow-user", "kubeflow-admin"] :
    {
      display_name = display_name
      parent       = "customers/${local.gcp_workspace_customer_id}"
      group_key_id = "${display_name}@${local.gcp_workspace_domain_name}"
    }
  ]
}
