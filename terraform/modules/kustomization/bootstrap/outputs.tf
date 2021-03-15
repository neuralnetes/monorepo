output "manifests_map" {
  value = [
    kustomization_resource.p0,
    kustomization_resource.p1,
    kustomization_resource.p2,
  ]
}