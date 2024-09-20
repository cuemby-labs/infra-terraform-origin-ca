#
# Install CRDs
#

resource "null_resource" "apply_crds" {

  provisioner "local-exec" {
    # Primero, crea un archivo temporal con el contenido del kubeconfig
    command = <<EOT
      echo "${var.kubeconfig_content}" > /tmp/kubeconfig
      KUBECONFIG=/tmp/kubeconfig kubectl apply -f https://raw.githubusercontent.com/cloudflare/origin-ca-issuer/${var.crds_version}/deploy/crds/cert-manager.k8s.cloudflare.com_originissuers.yaml
    EOT
  }

  provisioner "local-exec" {
    # Aplica el segundo CRD usando el mismo archivo temporal de kubeconfig
    command = "KUBECONFIG=/tmp/kubeconfig kubectl apply -f https://raw.githubusercontent.com/cloudflare/origin-ca-issuer/${var.crds_version}/deploy/crds/cert-manager.k8s.cloudflare.com_clusteroriginissuers.yaml"
  }
}

#
# Install Origin CA Issuer 
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

  # values     = [file("${path.module}/values.yaml")]

  # values = [
  #   templatefile("${path.module}/values.yaml.tpl", {
  #     harbor_admin_password = var.harbor_admin_password,
  #     domain_name           = var.domain_name,
  #     dash_domain_name      = var.dash_domain_name,
  #     environment           = var.environment

  #   })
  # ]
  set {
    name  = "global.rbac.create"
    value = "true"
  }
}

# resource "kubernetes_manifest" "origin_ca" {
#   manifest = yamldecode(file("${path.module}/value.yaml"))
# }

#
# Walrus information
#

locals {
  context = var.context
}