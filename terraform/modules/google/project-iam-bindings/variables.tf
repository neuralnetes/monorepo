variable "project_iam_bindings" {
  type = list(object({
    bindings = map(list(string))
    project = string
  }))
}
