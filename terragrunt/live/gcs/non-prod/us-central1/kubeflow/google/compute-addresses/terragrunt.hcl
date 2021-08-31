terraform {
  source = "github.com/neuralnetes/monorepo.git//terraform/modules/google/compute-addresses?ref=main"
}

include {
  path = find_in_parent_folders()
}

dependency "kubeflow_project" {
  config_path = "${get_parent_terragrunt_dir()}/non-prod/global/kubeflow/google/project"
}

locals {
  region = "us-central1"
}

inputs = {
  regional_addresses = [
    {
      project      = dependency.kubeflow_project.outputs.project_id
      name         = "istio-ingressgateway"
      address_type = "EXTERNAL"
      region       = local.region
      purpose      = ""
      subnetwork   = ""
    },
    {
      project      = dependency.kubeflow_project.outputs.project_id
      name         = "istio-ingressgateway-02"
      address_type = "EXTERNAL"
      region       = local.region
      purpose      = ""
      subnetwork   = ""
    }
  ]
}
