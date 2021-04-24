terraform {
  source = "github.com/neuralnetes/monorepo.git//terraform/modules/google/container-clusters?ref=main"
}

include {
  path = find_in_parent_folders()
}

dependency "compute_project" {
  config_path = "${get_parent_terragrunt_dir()}/non-prod/global/compute/google/project"
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
      add_cluster_firewall_rules = true
      cluster_autoscaling = {
        enabled             = true
        autoscaling_profile = "BALANCED"
        max_cpu_cores       = 4
        min_cpu_cores       = 1
        max_memory_gb       = 16
        min_memory_gb       = 1
      }
      firewall_inbound_ports = [
        "443",
        "6443",
        "8080",
        "8443",
        "9443",
        "10250",
        "15014",
        "15017"
      ]
      initial_node_count = 1
      ip_range_services  = dependency.subnetworks.outputs.subnets["us-central1/cluster-${dependency.random_string.outputs.result}"].secondary_ip_range[0].range_name
      ip_range_pods      = dependency.subnetworks.outputs.subnets["us-central1/cluster-${dependency.random_string.outputs.result}"].secondary_ip_range[1].range_name
      kubernetes_version = "latest"
      master_authorized_networks = [
        {
          cidr_block   = "0.0.0.0/0"
          display_name = "all-for-testing"
        }
      ]
      master_ipv4_cidr_block = "192.168.0.0/28"
      name                   = "cluster-${dependency.random_string.outputs.result}"
      network                = dependency.vpc.outputs.network_name
      network_project_id     = dependency.vpc.outputs.project_id
      node_pools = [
        {
          machine_type = "e2-standard-4"
          max_count    = 10
          min_count    = 1
          name         = "cluster-${dependency.random_string.outputs.result}-cpu-01"
          preemptible  = true
        },
        {
          accelerator_count = 1
          accelerator_type  = "nvidia-tesla-t4"
          machine_type      = "n1-standard-4"
          max_count         = 1
          min_count         = 0
          name              = "cluster-${dependency.random_string.outputs.result}-gpu-01"
          preemptible       = true
        }
      ]
      node_pools_tags = {
        all = []
      }
      node_pools_oauth_scopes = {
        all = [
          "https://www.googleapis.com/auth/cloud-platform"
        ]
      }
      project_id               = dependency.compute_project.outputs.project_id
      region                   = "us-central1"
      regional                 = false
      remove_default_node_pool = true
      service_account          = dependency.service_accounts.outputs.service_accounts_map["cluster-${dependency.random_string.outputs.result}"].email
      subnetwork               = dependency.subnetworks.outputs.subnets["us-central1/cluster-${dependency.random_string.outputs.result}"].name
      zones                    = ["us-central1-a"]
    }
  ]
}
