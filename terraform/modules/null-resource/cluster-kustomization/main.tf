resource "null_resource" "kustomize_cluster" {
  provisioner "local-exec" {
    interpreter = ["bash", "-c"]
    command     = "cd ${var.github_workspace} && bash/kustomize/kustomize_cluster.sh"
    environment = {
      CLUSTER_NAME         = var.cluster_name
      GITHUB_OWNER         = var.github_owner
      GITHUB_CLIENT_ID     = var.github_client_id
      GITHUB_CLIENT_SECRET = var.github_client_secret
      GITHUB_OWNER         = var.github_owner
      GITHUB_WORKSPACE     = var.github_workspace
      COMPUTE_PROJECT      = var.compute_project
      IAM_PROJECT          = var.iam_project
      KUBEFLOW_PROJECT     = var.kubeflow_project
      NETWORK_PROJECT      = var.network_project
    }
  }
  triggers = var.triggers
}

resource "null_resource" "git_commit" {
  depends_on = [null_resource.kustomize_cluster]
  provisioner "local-exec" {
    interpreter = ["bash", "-c"]
    command     = <<-EOF
      cd ${var.github_workspace} \
        && git pull \
        && git add kustomize \
        && git commit -m "cluster kustomize ${var.cluster_name}" \
        && git push
EOF
  }
  triggers = var.triggers
}
