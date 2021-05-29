locals {
  cluster_network_split = split("/", data.google_container_cluster.cluster.network)
  network_project       = local.cluster_network_split[1]
  network_name          = reverse(local.cluster_network_split)[0]
  http_port = [
    for http in google_compute_instance_group_named_port.http :
    http.port
  ][0]
  http_port_name = [
    for http in google_compute_instance_group_named_port.http :
    http.name
  ][0]
}

data "google_container_cluster" "cluster" {
  name     = var.cluster_name
  location = var.cluster_location
  project  = var.cluster_project
}

data "google_compute_instance_group" "instance_groups" {
  for_each  = toset(data.google_container_cluster.cluster.instance_group_urls)
  self_link = each.value
}

data "google_compute_instance" "instances" {
  for_each = toset(flatten([
    for instance_group_url, instance_group in data.google_compute_instance_group.instance_groups :
    instance_group.instances
  ]))
  self_link = each.value
}

data "google_compute_network" "network" {
  name    = local.network_name
  project = local.network_project
}

resource "google_compute_instance_group_named_port" "http" {
  for_each = data.google_compute_instance_group.instance_groups
  group    = each.value.self_link
  zone     = each.value.zone
  name     = "http"
  port     = 80
}

resource "google_compute_instance_group_named_port" "https" {
  for_each = data.google_compute_instance_group.instance_groups
  group    = each.value.self_link
  zone     = each.value.zone
  name     = "https"
  port     = 443
}

module "load_balancer" {
  source            = "github.com/terraform-google-modules/terraform-google-lb-http//?ref=v5.1.0"
  project           = data.google_compute_network.network.project
  name              = var.name
  ssl               = true
  private_key       = tls_private_key.cert.private_key_pem
  certificate       = tls_self_signed_cert.cert.cert_pem
  firewall_networks = [data.google_compute_network.network.name]
  firewall_projects = [data.google_compute_network.network.project]
  // Make sure when you create the cluster that you provide the `--tags` argument to add the appropriate `target_tags` referenced in the http module.
  target_tags = toset(flatten([
    for instance_self_link, instance in data.google_compute_instance.instances :
    instance.tags
  ]))
  create_url_map = true

  // Get selfLink URLs for the actual instance groups (not the manager) of the existing GKE cluster:
  //   gcloud compute instance-groups list --uri
  //
  // You also must add the named port on the existing GKE clusters instance group that correspond to the `service_port` and `service_port_name` referenced in the module definition.
  //   gcloud compute instance-groups set-named-ports INSTANCE_GROUP_NAME --named-ports=NAME:PORT
  // replace `INSTANCE_GROUP_NAME` with the name of your GKE cluster's instance group and `NAME` and `PORT` with the values of `service_port_name` and `service_port` respectively.
  backends = {
    default = {
      description                     = null
      protocol                        = "HTTP"
      port                            = local.http_port
      port_name                       = local.http_port_name
      timeout_sec                     = 10
      connection_draining_timeout_sec = null
      enable_cdn                      = false
      security_policy                 = null
      session_affinity                = null
      affinity_cookie_ttl_sec         = null
      custom_request_headers          = null

      health_check = {
        check_interval_sec  = null
        timeout_sec         = null
        healthy_threshold   = null
        unhealthy_threshold = null
        request_path        = "/"
        port                = local.http_port
        host                = null
        logging             = true
      }

      log_config = {
        enable      = true
        sample_rate = 1.0
      }

      groups = [
        for instance_group in data.google_compute_instance_group.instance_groups :
        {
          # Each node pool instance group should be added to the backend.
          group                        = instance_group.self_link
          balancing_mode               = null
          capacity_scaler              = null
          description                  = null
          max_connections              = null
          max_connections_per_instance = null
          max_connections_per_endpoint = null
          max_rate                     = null
          max_rate_per_instance        = null
          max_rate_per_endpoint        = null
          max_utilization              = null
        }
      ]

      iap_config = {
        enable               = false
        oauth2_client_id     = ""
        oauth2_client_secret = ""
      }
    }
  }
}
