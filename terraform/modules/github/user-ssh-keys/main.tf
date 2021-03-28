module "user_ssh_keys" {
  for_each = local.user_ssh_keys_map
  source   = "https://github.com/neuralnetes/monorepo.git//terraform/modules/github/user-ssh-key?ref=main"
  title    = each.value["title"]
}

locals {
  user_ssh_keys_map = {
    for user_ssh_key in var.user_ssh_keys :
    user_ssh_key["title"] => user_ssh_key
  }
}