output "manifests_map" {
  value = {
    p0 = kustomization_resource.p0,
    p1 = kustomization_resource.p1,
    p2 = kustomization_resource.p2,
  }
}