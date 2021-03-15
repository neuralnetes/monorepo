variable "bindings" {
  type = list(object({
    key      = string
    bindings = map(list(string))
    projects = list(string)
  }))
}
