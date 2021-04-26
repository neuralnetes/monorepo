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

  triggers = {
    always            = timestamp()
    kustomize_cluster = filebase64sha256("${var.github_workspace}/bash/kustomize/kustomize_cluster.sh")
  }
}

resource "null_resource" "git_commit" {
  depends_on = [null_resource.kustomize_cluster]
  provisioner "local-exec" {
    interpreter = ["bash", "-c"]
    command     = <<-EOF
      cd ${var.github_workspace} \
      && git config --global user.email ${var.github_email} \
      && git config --global user.name ${var.github_user} \
      && git add kustomize \
      && git commit -m "cluster kustomize ${var.compute_project}" \
      && git push
EOF
    environment = {
      GITHUB_TOKEN = var.github_token
    }
  }
}
