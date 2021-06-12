variable "identity_group_memberships" {
  type = list(object({
    name          = string
    group         = string
    roles_name    = string
    member_key_id = string
  }))
}