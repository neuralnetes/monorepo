data "kustomization_build" "root" {
  path = var.path
}

resource "kustomization_resource" "manifests" {
  for_each = data.kustomization_build.root.ids

  manifest = data.kustomization_build.root.manifests[each.value]
}
