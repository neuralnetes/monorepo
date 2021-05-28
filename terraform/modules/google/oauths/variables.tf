variable "oauths" {
  type = list(object({
    application_title = string
    support_email     = string
    project           = string
  }))
}
