variable "repositories" {
  type = list(object({
    full_name = string
  }))
}