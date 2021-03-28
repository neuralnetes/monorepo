module "notifications" {
  for_each          = local.notifications_map
  source            = "github.com/neuralnetes/monorepo.git//terraform/modules/gcp/cloud-storage-notification?ref=main"
  project_id        = each.value["project_id"]
  bucket_name       = each.value["bucket_name"]
  pubsub_topic_name = each.value["pubsub_topic_name"]
  custom_attributes = each.value["custom_attributes"]
}

locals {
  notifications_map = {
    for notification in var.notifications :
    notification["bucket_name"] => notification
  }
}