terraform {
  source = "github.com/neuralnetes/monorepo.git//terraform/modules/gcp/container-clusters?ref=main"
}

include {
  path = find_in_parent_folders()
}

dependency "compute_project" {
  config_path = "${get_parent_terragrunt_dir()}/non-prod/global/compute/gcp/project"
}

dependency "service_accounts" {
  config_path = "${get_parent_terragrunt_dir()}/non-prod/global/iam/gcp/service-accounts"
}

dependency "project_iam_bindings" {
  config_path = "${get_parent_terragrunt_dir()}/non-prod/global/iam/gcp/project-iam-bindings"
}

dependency "vpc" {
  config_path = "${get_parent_terragrunt_dir()}/non-prod/global/network/gcp/vpc"
}

dependency "subnetworks" {
  config_path = "${get_parent_terragrunt_dir()}/non-prod/us-central1/network/gcp/subnetworks"
}

dependency "firewall" {
  config_path = "${get_parent_terragrunt_dir()}/non-prod/us-central1/network/gcp/firewall"
}

dependency "random_string" {
  config_path = "${get_parent_terragrunt_dir()}/non-prod/global/terraform/random/random-string"
}

locals {
}

inputs = {
  container_clusters = [
    for container_cluster in [
      {
        project_id         = dependency.compute_project.outputs.project_id
        name               = "cluster-${dependency.random_string.outputs.result}"
        network            = dependency.vpc.outputs.network_name
        network_project_id = dependency.vpc.outputs.project_id
        subnetwork         = dependency.subnetworks.outputs.subnets["us-central1/cluster-${dependency.random_string.outputs.result}"].name
        ip_range_services  = dependency.subnetworks.outputs.subnets["us-central1/cluster-${dependency.random_string.outputs.result}"].secondary_ip_range[0].range_name
        ip_range_pods      = dependency.subnetworks.outputs.subnets["us-central1/cluster-${dependency.random_string.outputs.result}"].secondary_ip_range[1].range_name
        node_pools = [
          {
            name         = "cluster-${dependency.random_string.outputs.result}-cpu-01"
            machine_type = "e2-standard-4"
            min_count    = 1
            max_count    = 10
            disk_size_gb = 100
            disk_type    = "pd-standard"
            image_type   = "COS"
            preemptible  = true
          },
          {
            name              = "cluster-${dependency.random_string.outputs.result}-gpu-01"
            machine_type      = "n1-standard-4"
            min_count         = 0
            max_count         = 1
            accelerator_type  = "nvidia-tesla-t4"
            accelerator_count = 1
            disk_size_gb      = 100
            disk_type         = "pd-standard"
            image_type        = "COS"
            preemptible       = true
          }
        ]
        service_account = dependency.service_accounts.outputs.service_accounts_map["cluster-${dependency.random_string.outputs.result}"].email
      }
    ] :
    merge(
      local.container_cluster_defaults,
      container_cluster
    )
  ]
}
