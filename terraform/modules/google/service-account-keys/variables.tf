variable "service_account_keys" {
  type = list(object({
    service_account_id = string
  }))
}
