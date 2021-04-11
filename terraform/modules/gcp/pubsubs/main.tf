module "topics" {
  for_each           = local.topics_map
  source             = "github.com/terraform-google-modules/terraform-google-pubsub.git//?ref=v1.8.0"
  topic              = each.value["topic"]
  project_id         = each.value["project_id"]
  push_subscriptions = each.value["push_subscriptions"]
  pull_subscriptions = each.value["pull_subscriptions"]
}


locals {
  topics_map = {
    for topic in var.topics :
    topic["topic"] => topic
  }
}