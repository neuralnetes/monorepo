terraform {
  source = "https://github.com/neuralnetes/monorepo.git//terraform/modules/gcp/auth?ref=main"
}

include {
  path = find_in_parent_folders()
}

inputs = {}
