terraform {
  required_providers {
    # https://registry.terraform.io/providers/kbst/kustomization/latest
    kustomization = {
      source  = "kbst/kustomization"
      version = "0.4.3"
    }
  }
}

provider "kustomization" {
  kubeconfig_raw = var.kubeconfig_raw
}

data "kustomization_build" "root" {
  path = var.path
}

resource "kustomization_resource" "p0" {
  for_each = data.kustomization_build.root.ids

  manifest = data.kustomization_build.root.manifests[each.value]
}
