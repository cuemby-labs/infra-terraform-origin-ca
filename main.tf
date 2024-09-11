locals {
  context = var.context
}

module "submodule" {
  source = "./modules/submodule"

  message = "Hello, submodule"
}

#
# Origin CA Issuer 
#

resource "kubernetes_namespace" "this" {
  count = length(
    try(
      [for ns in data.kubernetes_namespace.existing.namespaces : ns.metadata.name if ns.metadata.name == var.namespace_name],
      []
    )
  ) == 0 ? 1 : 0

  metadata {
    name = var.namespace_name
  }
}

data "kubernetes_namespace" "existing" {
  for_each = {
    for ns in kubernetes_namespace.this : ns.metadata.name => ns
  }

  metadata {
    name = var.namespace_name
  }
}

resource "helm_release" "this" {
  name       = var.helm_release_name
  repository = "oci://ghcr.io/cloudflare/origin-ca-issuer-charts/"
  chart      = "origin-ca-issuer"
  version    = var.helm_chart_version
  namespace  = var.namespace_name

  # values     = [file("${path.module}/values.yaml")]

  # set {
  #   name  = "certmanager.namespace"
  #   value = "ccp-core"
  # }
}