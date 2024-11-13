#
# Install CRDs
#

module "kubernetes_manifest" {
  source = "./modules/kubernetes_manifest"

  manifests_urls = var.manifests_urls
}

#
# Origin CA Resources
#

resource "kubernetes_namespace" "origin_ca" {
  metadata {
    name = var.namespace_name
  }
}

resource "helm_release" "origin_ca" {
  name       = var.helm_release_name
  repository = "oci://ghcr.io/cloudflare/origin-ca-issuer-charts/"
  chart      = "origin-ca-issuer"
  version    = var.helm_chart_version
  namespace  = var.namespace_name

  set {
    name  = "global.rbac.create"
    value = "true"
  }
}

resource "kubernetes_secret" "origin_ca_issuer_secret" {
  metadata {
    name      = "origin-ca-issuer-secret"
    namespace = var.namespace_name
  }

  data = {
    key = var.key
  }

  type = "Opaque"
}

#
# Walrus Information
#

locals {
  context = var.context
}