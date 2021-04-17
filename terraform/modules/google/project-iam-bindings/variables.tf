variable "bindings" {
  type = list(object({
    bindings = map(list(string))
    project = list(string)
  }))
}
