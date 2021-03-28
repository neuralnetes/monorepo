terraform {
  source = "https://github.com/neuralnetes/monorepo.git//terraform/modules/github/user-ssh-keys?ref=main"
}

include {
  path = find_in_parent_folders()
}

dependency "random_string" {
  config_path = "${get_parent_terragrunt_dir()}/non-prod/global/terraform/random/random-string"
}

inputs = {
  user_ssh_keys = [
    {
      title = "terraform-${dependency.random_string.outputs.result}"
    }
  ]
}
