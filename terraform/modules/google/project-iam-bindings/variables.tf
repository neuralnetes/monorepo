variable "project_iam_bindings" {
  type = list(object({
    name     = string
    bindings = map(list(string))
    project  = string
  }))
}
