variable "bindings" {
  type = list(object({
    bindings     = map(list(string))
    organization = string
  }))
}