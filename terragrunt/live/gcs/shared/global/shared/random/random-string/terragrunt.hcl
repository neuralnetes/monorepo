terraform {
  source = "github.com/neuralnetes/monorepo.git//terraform/modules/random/random-string?ref=main"
}

include {
  path = find_in_parent_folders()
}

inputs = {
  length = 4
}
