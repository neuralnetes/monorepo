terraform {
  source = "git::git@github.com:neuralnetes/infra-modules.git//github/repositories?ref=master"
}

include {
  path = find_in_parent_folders()
}

inputs = {
  repositories = [
    {
      full_name = "neuralnetes/functions"
    }
  ]
}