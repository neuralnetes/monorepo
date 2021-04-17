variable "service_account_iam_bindings" {
  type = list(object({
    bindings        = map(list(string))
    service_account = string
  }))
}