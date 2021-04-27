resource "null_resource" "kustomize_cluster" {
  provisioner "local-exec" {
    interpreter = ["bash", "-c"]
    command     = "cd ${var.github_workspace} && bash/kustomize/kustomize_cluster.sh"
    environment = {
      CLUSTER_NAME    = var.cluster_name
      COMPUTE_PROJECT = var.compute_project
      IAM_PROJECT     = var.iam_project
      NETWORK_PROJECT = var.network_project
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
