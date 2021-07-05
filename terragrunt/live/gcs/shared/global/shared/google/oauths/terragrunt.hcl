terraform {
  source = "github.com/neuralnetes/monorepo.git//terraform/modules/google/oauths?ref=main"
}

include {
  path = find_in_parent_folders()
}

locals {
  gcp_workspace_domain_name = get_env("GCP_WORKSPACE_DOMAIN_NAME")
}

inputs = {
  oauths = []
}

skip = true
