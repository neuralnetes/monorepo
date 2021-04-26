resource "null_resource" "kustomize_cluster" {
  provisioner "local-exec" {
    interpreter = ["bash", "-c"]
    command     = "cd ${var.github_workspace} && bash/kustomize/kustomize_cluster.sh"
    environment = {
      COMPUTE_PROJECT = var.compute_project
      IAM_PROJECT     = var.iam_project
      NETWORK_PROJECT = var.network_project
    }
  }
}

resource "null_resource" "git_commit" {
  depends_on = [null_resource.kustomize_cluster]
  provisioner "local-exec" {
    interpreter = ["bash", "-c"]
    command     = "cd ${var.github_workspace} && git add kustomize && git commit -m 'cluster kustomize ${var.compute_project}' && git push"
    environment = {
      GITHUB_TOKEN = var.github_token
    }
  }
}
