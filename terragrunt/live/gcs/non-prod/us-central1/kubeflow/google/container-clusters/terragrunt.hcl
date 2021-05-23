terraform {
  source = "github.com/neuralnetes/monorepo.git//terraform/modules/google/container-clusters?ref=main"
}

include {
  path = find_in_parent_folders()
}

dependency "kubeflow_project" {
  config_path = "${get_parent_terragrunt_dir()}/non-prod/global/kubeflow/google/project"
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
      cluster_autoscaling = {
        enabled             = true
        autoscaling_profile = "BALANCED"
        max_cpu_cores       = 2
        min_cpu_cores       = 0
        max_memory_gb       = 8
        min_memory_gb       = 0
      }
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
          max_count    = 5
          min_count    = 3
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
        all = [
          dependency.tags.outputs.tags_map["private"]
        ]
      }
      node_pools_oauth_scopes = {
        all = [
          "https://www.googleapis.com/auth/cloud-platform"
        ]
      }
      project_id               = dependency.kubeflow_project.outputs.project_id
      region                   = "us-central1"
      regional                 = false
      remove_default_node_pool = true
      subnetwork               = dependency.subnetworks.outputs.subnets["us-central1/cluster-${dependency.random_string.outputs.result}"].name
      zones                    = ["us-central1-a"]
    }
  ]
}
