variable "topics" {
  type = list(object({
    topic              = string
    project_id         = string
    push_subscriptions = list(any)
    pull_subscriptions = list(any)
  }))
}
