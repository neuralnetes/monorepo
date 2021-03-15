terraform {
  source = "git::git@github.com:neuralnetes/infra-modules.git//gcp/auth?ref=master"
}

include {
  path = find_in_parent_folders()
}

inputs = {}
