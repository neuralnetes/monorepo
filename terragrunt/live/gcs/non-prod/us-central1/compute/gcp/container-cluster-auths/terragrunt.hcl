terraform {
  source = "github.com/neuralnetes/monorepo.git//terraform/modules/gcp/container-cluster-auths?ref=main"
}

include {
  path = find_in_parent_folders()
}

dependency "container_clusters" {
  config_path = "${get_parent_terragrunt_dir()}/non-prod/us-central1/compute/gcp/container-clusters"
}

inputs = {
  container_cluster_auths = [
    for container_cluster_name, container_cluster in container_clusters :
    {
      project_id   = container_cluster.project_id
      cluster_name = container_cluster_name
      location     = string
    }
  ]
}