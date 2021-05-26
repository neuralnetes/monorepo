variable "service_account_access_tokens" {
  type = list(object({
    target_service_account = string
    scopes                 = list(string)
    lifetime               = string
  }))
}