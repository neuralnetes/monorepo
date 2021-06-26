variable "identity_groups" {
  type = list(object({
    display_name         = string
    initial_group_config = string
    parent               = string
    group_key_id         = string
  }))
}
