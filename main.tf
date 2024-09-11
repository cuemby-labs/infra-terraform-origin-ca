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

data "kubernetes_namespace" "existing" {
  metadata {
    name = var.namespace_name
  }
}

resource "kubernetes_namespace" "this" {
  count = length(data.kubernetes_namespace.existing.items) == 0 ? 1 : 0

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