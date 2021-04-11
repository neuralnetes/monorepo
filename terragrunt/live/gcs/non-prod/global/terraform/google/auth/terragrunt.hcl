terraform {
  source = "github.com/neuralnetes/monorepo.git//terraform/modules/google/auth?ref=main"
}

include {
  path = find_in_parent_folders()
}

inputs = {}
