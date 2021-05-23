terraform {
  source = "github.com/neuralnetes/monorepo.git//terraform/modules/google/compute-instances?ref=main"
}

include {
  path = find_in_parent_folders()
}

dependency "compute_project" {
  config_path = "${get_parent_terragrunt_dir()}/non-prod/global/kubeflow/google/project"
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
  compute_instances = [
    {
      name                  = "openvpn-${dependency.random_string.output.result}"
      machine_type          = "e2-micro"
      image_project         = "ubuntu-os-cloud"
      image_family          = "ubuntu-2004-lts"
      project               = dependency.compute_project.outputs.project_id
      zone                  = "us-central1-a"
      network               = dependency.vpc.outputs.network_self_link
      subnetwork            = dependency.subnetworks.outputs.subnets["us-central1/cluster-${dependency.random_string.outputs.result}"].self_link
      service_account_email = dependency.service_accounts.outputs.service_accounts_map["openvpn"].email
      tags = [
        dependency.tags.outputs.tags_map["vpn"]
      ]
      metadata_startup_script = templatefile("templates/openvpn.tpl", {
        url  = "https://cloud-backend.openvpn.com/cvpn/api/v1/scripts/VWJ1bnR1IDIwLjA0/ubuntu_20_04.sh"
        name = "ubuntu_20_04.sh"
      })
    }
  ]
}
