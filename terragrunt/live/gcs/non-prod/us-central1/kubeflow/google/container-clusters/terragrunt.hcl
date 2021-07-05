terraform {
  source = "github.com/neuralnetes/monorepo.git//terraform/modules/google/container-clusters?ref=main"
}

include {
  path = find_in_parent_folders()
}

dependency "artifact_project" {
  config_path = "${get_parent_terragrunt_dir()}/non-prod/global/artifact/google/project"
}

dependency "kubeflow_project" {
  config_path = "${get_parent_terragrunt_dir()}/non-prod/global/kubeflow/google/project"
}

dependency "service_project_subnetworks" {
  config_path = "${get_parent_terragrunt_dir()}/non-prod/us-central1/kubeflow/google/service-project-subnetworks"
}

dependency "vpc" {
  config_path = "${get_parent_terragrunt_dir()}/non-prod/global/network/google/vpc"
}

dependency "subnetworks" {
  config_path = "${get_parent_terragrunt_dir()}/non-prod/us-central1/network/google/subnetworks"
}

dependency "firewall_rules" {
  config_path = "${get_parent_terragrunt_dir()}/non-prod/us-central1/network/google/firewall-rules"
}

dependency "tags" {
  config_path = "${get_parent_terragrunt_dir()}/shared/global/shared/google/tags"
}

locals {
  region = "us-central1"
  zone   = "us-central1-a"
}

inputs = {
  container_clusters = [
    {
      create_service_account = true
      grant_registry_access  = true
      initial_node_count     = 1
      ip_range_pods          = "${dependency.kubeflow_project.outputs.project_id}-pods"
      ip_range_services      = "${dependency.kubeflow_project.outputs.project_id}-services"
      kubernetes_version     = "1.20.7-gke.1800"
      master_authorized_networks = [
        {
          cidr_block   = "0.0.0.0/0"
          display_name = "all-for-testing"
        }
      ]
      master_ipv4_cidr_block = "10.7.0.0/28"
      name                   = dependency.kubeflow_project.outputs.project_id
      network                = dependency.vpc.outputs.vpc_map["vpc-01"].network_name
      network_project_id     = dependency.vpc.outputs.vpc_map["vpc-01"].project_id
      node_pools = [
        {
          machine_type       = "e2-standard-4"
          initial_node_count = 5
          max_count          = 8
          min_count          = 3
          name               = "cpu-01"
          preemptible        = true
          image_type         = "COS"
          auto_repair        = true
          auto_upgrade       = false
        },
        {
          accelerator_count = 1
          accelerator_type  = "nvidia-tesla-t4"
          machine_type      = "n1-standard-4"
          max_count         = 1
          min_count         = 0
          name              = "gpu-01"
          preemptible       = true
          image_type        = "COS"
          auto_repair       = true
          auto_upgrade      = false
        }
      ]
      node_pools_tags = {
        all = [
          dependency.tags.outputs.tags_map["public"]
        ]
      }
      node_pools_oauth_scopes = {
        all = [
          "https://www.googleapis.com/auth/cloud-platform"
        ]
      }
      project_id = dependency.kubeflow_project.outputs.project_id
      region     = local.region
      regional   = false
      registry_project_ids = [
        dependency.artifact_project.outputs.project_id
      ]
      remove_default_node_pool = true
      service_account          = ""
      subnetwork               = dependency.subnetworks.outputs.subnets["${local.region}/${dependency.kubeflow_project.outputs.project_id}-nodes"].name
      zones                    = [local.zone]
    }
  ]
}

skip = true