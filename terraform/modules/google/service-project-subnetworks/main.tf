locals {
  service_project_subnetworks_map = {
    for service_project_subnetwork in var.service_project_subnetworks :
    service_project_subnetwork["subnetwork_self_link"] => service_project_subnetwork
  }
}

module "service_project_subnetworks" {
  for_each             = local.service_project_subnetworks_map
  source               = "github.com/neuralnetes/monorepo.git//terraform/modules/google/service-project-subnetwork//?ref=main"
  host_project_id      = each.value["host_project_id"]
  service_project_id   = each.value["service_project_id"]
  subnetwork_self_link = each.value["subnetwork_self_link"]
  region               = each.value["region"]
}