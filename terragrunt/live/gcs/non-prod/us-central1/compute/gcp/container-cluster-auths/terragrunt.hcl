terraform {
  source = "github.com/neuralnetes/monorepo.git//terraform/modules/gcp/container-clusters?ref=main"
}

include {
  path = find_in_parent_folders()
}

dependency "container_clusters" {
  config_path = "${get_parent_terragrunt_dir()}/non-prod/us-central1/compute/gcp/container-clusters"
}

inputs = {
  container_clusters = [
    {

    }
  ]
}