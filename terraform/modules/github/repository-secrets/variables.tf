variable "secrets" {
  type = list(object({
    repository      = string
    secret_name     = string
    plaintext_value = string
  }))
}