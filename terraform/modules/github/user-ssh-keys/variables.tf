variable "user_ssh_keys" {
  type = list(object({
    title = string
  }))
}
