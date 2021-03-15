terraform {
  source = "git::git@github.com:neuralnetes/infra-modules.git//github/branches?ref=master"
}

include {
  path = find_in_parent_folders()
}

dependency "repositories" {
  config_path = "${get_terragrunt_dir()}/../repositories"
}

inputs = {
  branches = [
    for repo_key, repo in dependency.repositories.outputs.repositories_map :
    {
      repository = reverse(split("/", repo.full_name))[0]
      branch     = "main"
    }
  ]
}