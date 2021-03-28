terraform {
  source = "https://github.com/neuralnetes/monorepo.git//terraform/modules/github/repositories?ref=main"
}

include {
  path = find_in_parent_folders()
}

inputs = {
  repositories = [
    {
      full_name = "neuralnetes/monorepo"
    }
  ]
}