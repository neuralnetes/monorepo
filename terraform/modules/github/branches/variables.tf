variable "branches" {
  type = list(object({
    repository = string
    branch     = string
  }))
}
