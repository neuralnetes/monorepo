variable "identity_groups" {
  type = list(object({
    display_name = string
    parent       = string
    group_key_id = string
  }))
}
