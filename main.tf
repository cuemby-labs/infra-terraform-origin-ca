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

resource "kubernetes_namespace" "origin_ca_issuer" {
  metadata {
    name = var.namespace_name
  }
}

resource "helm_release" "origin_ca_issuer" {
  name       = var.helm_release_name
  repository = "oci://ghcr.io/cloudflare/origin-ca-issuer-charts/"
  chart      = "origin-ca-issuer"
  version    = var.helm_chart_version
  namespace  = var.namespace_name

  values     = [file("${path.module}/values.yaml")]

  # set {
  #   name  = "certmanager.namespace"
  #   value = "ccp-core"
  # }
}