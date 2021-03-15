terraform {
  source = "git::git@github.com:neuralnetes/infra-modules.git//random/random-string?ref=master"
}

include {
  path = find_in_parent_folders()
}

inputs = {
  length = 4
}
