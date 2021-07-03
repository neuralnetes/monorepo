terraform {
  source = "github.com/neuralnetes/monorepo.git//terraform/modules/google/container-clusters?ref=main"
}

include {
  path = find_in_parent_folders()
}

dependency "artifact_project" {
  config_path = "${get_parent_terragrunt_dir()}/non-prod/global/artifact/google/project"
}

dependency "management_project" {
  config_path = "${get_parent_terragrunt_dir()}/non-prod/global/management/google/project"
}

dependency "iam_project" {
  config_path = "${get_parent_terragrunt_dir()}/non-prod/global/iam/google/project"
}

dependency "service_accounts" {
  config_path = "${get_parent_terragrunt_dir()}/non-prod/global/iam/google/service-accounts"
}

dependency "project_iam_bindings" {
  config_path = "${get_parent_terragrunt_dir()}/non-prod/global/iam/google/project-iam-bindings"
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

dependency "random_string" {
  config_path = "${get_parent_terragrunt_dir()}/non-prod/global/terraform/random/random-string"
}

dependency "tags" {
  config_path = "${get_parent_terragrunt_dir()}/non-prod/global/terraform/google/tags"
}

inputs = {
  container_clusters = [
    {
      initial_node_count = 1
      ip_range_pods      = dependency.subnetworks.outputs.subnets["us-central1/management-${dependency.random_string.outputs.result}-nodes"].secondary_ip_range[0].range_name
      ip_range_services  = dependency.subnetworks.outputs.subnets["us-central1/management-${dependency.random_string.outputs.result}-nodes"].secondary_ip_range[1].range_name
      kubernetes_version = "1.20.7-gke.1800"
      master_authorized_networks = [
        {
          cidr_block   = "0.0.0.0/0"
          display_name = "all-for-testing"
        }
      ]
      master_ipv4_cidr_block = "192.168.0.0/28"
      name                   = "management-${dependency.random_string.outputs.result}-nodes"
      network                = dependency.vpc.outputs.vpc_map["vpc-${dependency.random_string.outputs.result}"].network_name
      network_project_id     = dependency.vpc.outputs.vpc_map["vpc-${dependency.random_string.outputs.result}"].project_id
      node_pools = [
        {
          machine_type       = "e2-medium"
          initial_node_count = 5
          max_count          = 8
          min_count          = 3
          name               = "cpu-00"
          preemptible        = true
          image_type         = "COS"
          auto_repair        = true
          auto_upgrade       = false
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
      project_id               = dependency.management_project.outputs.project_id
      region                   = "us-central1"
      regional                 = false
      remove_default_node_pool = true
      subnetwork               = dependency.subnetworks.outputs.subnets["us-central1/management-${dependency.random_string.outputs.result}-nodes"].name
      create_service_account   = true
      service_account          = ""
      zones                    = ["us-central1-a"]
      grant_registry_access    = true
      registry_project_ids = [
        dependency.artifact_project.outputs.project_id
      ]
    }
  ]
}
