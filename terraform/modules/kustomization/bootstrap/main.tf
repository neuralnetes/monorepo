data "kustomization_build" "root" {
  path = var.path
}

resource "kustomization_resource" "p0" {
  for_each = data.kustomization_build.root.ids_prio[0]

  manifest = data.kustomization_build.root.manifests[each.value]
}

resource "kustomization_resource" "p1" {
  for_each = data.kustomization_build.root.ids_prio[1]

  manifest = data.kustomization_build.root.manifests[each.value]

  depends_on = [kustomization_resource.p0]
}

resource "kustomization_resource" "p2" {
  for_each = data.kustomization_build.root.ids_prio[2]

  manifest = data.kustomization_build.root.manifests[each.value]

  depends_on = [kustomization_resource.p1]
}
