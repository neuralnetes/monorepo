terraform {
  source = "github.com/neuralnetes/monorepo.git//terraform/modules/google/compute-addresses?ref=main"
}

include {
  path = find_in_parent_folders()
}

dependency "management_project" {
  config_path = "${get_parent_terragrunt_dir()}/non-prod/global/management/google/project"
}

locals {
  region = "us-central1"
}

inputs = {
  regional_addresses = [
    {
      project      = dependency.management_project.outputs.project_id
      name         = "istio-ingressgateway"
      address_type = "EXTERNAL"
      region       = local.region
      purpose      = ""
      subnetwork   = ""
    }
  ]
}
