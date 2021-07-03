terraform {
  source = "github.com/neuralnetes/monorepo.git//terraform/modules/google/container-cluster-auths?ref=main"
}

include {
  path = find_in_parent_folders()
}

dependency "container_clusters" {
  config_path = "${get_parent_terragrunt_dir()}/non-prod/us-central1/management/google/container-clusters"
}

inputs = {
  container_cluster_auths = [
    for container_cluster in values(dependency.container_clusters.outputs.container_clusters_map) :
    {
      project_id   = container_cluster["project_id"]
      cluster_name = container_cluster["cluster_name"]
      location     = container_cluster["location"]
    }
  ]
}