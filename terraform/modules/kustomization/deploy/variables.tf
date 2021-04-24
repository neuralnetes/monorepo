variable "path" {
  type = string
}

variable "kustomize_options" {
  type = map(string)
  default = {
    load_restrictor = "none"
  }
}
