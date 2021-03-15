terraform {
  source = "git::git@github.com:neuralnetes/monorepo.git//terraform/modules/gcp/container-clusters?ref=main"
}

include {
  path = find_in_parent_folders()
}

dependency "project" {
  config_path = "${get_parent_terragrunt_dir()}/non-prod/global/compute/gcp/project"
}

dependency "service_accounts" {
  config_path = "${get_parent_terragrunt_dir()}/non-prod/global/compute/gcp/service-accounts"
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
  config_path = "${get_parent_terragrunt_dir()}/non-prod/global/shared/random/random-string"
}

locals {
  container_cluster_defaults = {
    description                = "container cluster"
    regional                   = false
    region                     = "us-central1"
    zones                      = ["us-central1-a"]
    master_ipv4_cidr_block     = "192.168.0.0/28"
    autoscaling                = true
    http_load_balancing        = true
    horizontal_pod_autoscaling = true
    network_policy             = false
    enable_private_endpoint    = false
    enable_private_nodes       = true
    remove_default_node_pool   = true
    create_service_account     = false
    node_metadata              = "GKE_METADATA_SERVER"
    node_pools_oauth_scopes = {
      all = [
        "https://www.googleapis.com/auth/cloud-platform"
      ]
    }
    node_pools_tags = {
      all = [
        "private"
      ]
    }
    node_pools_taints = {
      all = []
    }
    node_pools_labels = {
      all = []
    }
    node_pools_metadata = {
      all = []
    }
    node_pools_linux_node_configs_sysctls = {
      all = []
    }
    add_cluster_firewall_rules = true
    kubernetes_version         = "latest"
    master_authorized_networks = [
      {
        cidr_block   = "0.0.0.0/0"
        display_name = "all-for-testing"
      }
    ]
    enable_vertical_pod_autoscaling    = false
    horizontal_pod_autoscaling         = true
    http_load_balancing                = true
    network_policy                     = false
    network_policy_provider            = "CALICO"
    datapath_provider                  = "DATAPATH_PROVIDER_UNSPECIFIED"
    maintenance_exclusions             = []
    maintenance_start_time             = "05:00"
    maintenance_end_time               = ""
    maintenance_recurrence             = ""
    initial_node_count                 = 0
    remove_default_node_pool           = true
    disable_legacy_metadata_endpoints  = true
    resource_usage_export_dataset_id   = ""
    enable_network_egress_export       = false
    enable_resource_consumption_export = false
    enable_kubernetes_alpha            = false
    cluster_autoscaling = {
      enabled             = false
      autoscaling_profile = "BALANCED"
      max_cpu_cores       = 0
      min_cpu_cores       = 0
      max_memory_gb       = 0
      min_memory_gb       = 0
    }
    stub_domains                  = {}
    upstream_nameservers          = []
    non_masquerade_cidrs          = ["10.0.0.0/8", "172.16.0.0/12", "192.168.0.0/16"]
    ip_masq_resync_interval       = "60s"
    ip_masq_link_local            = false
    configure_ip_masq             = false
    cluster_telemetry_type        = null
    logging_service               = "logging.googleapis.com/kubernetes"
    monitoring_service            = "monitoring.googleapis.com/kubernetes"
    create_service_account        = false
    grant_registry_access         = false
    registry_project_ids          = []
    basic_auth_username           = ""
    basic_auth_password           = ""
    issue_client_certificate      = false
    cluster_ipv4_cidr             = null
    cluster_resource_labels       = {}
    skip_provisioners             = true
    default_max_pods_per_node     = 110
    deploy_using_private_endpoint = false
    enable_private_endpoint       = false
    enable_private_nodes          = true
    master_ipv4_cidr_block        = "192.168.0.0/28"
    master_global_access_enabled  = true
    istio                         = false
    istio_auth                    = "AUTH_MUTUAL_TLS"
    dns_cache                     = false
    gce_pd_csi_driver             = false
    kalm_config                   = false
    config_connector              = false
    cloudrun                      = false
    cloudrun_load_balancer_type   = ""
    enable_pod_security_policy    = false
    sandbox_enabled               = false
    enable_intranode_visibility   = false
    authenticator_security_group  = ""
    node_metadata                 = "GKE_METADATA_SERVER"
    database_encryption = [
      {
        state    = "DECRYPTED"
        key_name = ""
      }
    ]
    identity_namespace          = "enabled"
    release_channel             = null
    enable_shielded_nodes       = true
    enable_binary_authorization = false
    add_cluster_firewall_rules  = true
    firewall_priority           = 1000
    firewall_inbound_ports = [
      "443",
      "10250",
      "6443",
      "15014",
      "15017",
      "8080"
    ]
    gcloud_upgrade                 = false
    add_shadow_firewall_rules      = false
    shadow_firewall_rules_priority = 999
    disable_default_snat           = false
    impersonate_service_account    = ""
    notification_config_topic      = ""
    enable_tpu                     = false
  }
}

inputs = {
  clusters = [
    merge(
      local.container_cluster_defaults,
      {
        project_id         = dependency.project.outputs.project_id
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
    )
  ]
}
