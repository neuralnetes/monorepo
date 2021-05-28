variable "service_account_iam_bindings" {
  type = list(object({
    name            = string
    bindings        = map(list(string))
    service_account = string
    project         = string
  }))
}