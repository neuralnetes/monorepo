variable "custom_iam_roles" {
  type = list(object({
    target_level         = string
    target_id            = string
    role_id              = string
    title                = string
    description          = string
    base_roles           = list(string)
    permissions          = list(string)
    excluded_permissions = list(string)
    members              = list(string)
  }))
}