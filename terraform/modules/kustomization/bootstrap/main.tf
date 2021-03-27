data "kustomization_build" "root" {
  path = var.path
}

resource "kustomization_resource" "p0" {
  for_each = data.kustomization_build.root.ids[0]

  manifest = data.kustomization_build.root.manifests[each.value]
}
