variable "bindings" {
  type = list(object({
    project         = string
    bindings        = map(list(string))
    service_account = string
  }))
}