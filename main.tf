#
# Install CRDs
#

data "http" "origin_ca_crds" {
  url = "https://raw.githubusercontent.com/cloudflare/origin-ca-issuer/${var.crds_version}/deploy/crds/cert-manager.k8s.cloudflare.com_originissuers.yaml"
}

data "kubectl_file_documents" "origin_ca_crds" {
  content = data.http.origin_ca_crds.body
}

resource "kubectl_manifest" "install_origin_ca_crds" {
  for_each   = data.kubectl_file_documents.origin_ca_crds.manifests
  yaml_body  = each.value
}

# resource "null_resource" "apply_crds" {

#   provisioner "local-exec" {
#     # Primero, crea un archivo temporal con el contenido del kubeconfig
#     command = <<EOT
#       echo "${var.kubeconfig_content}" > /tmp/kubeconfig
#       KUBECONFIG=/tmp/kubeconfig kubectl apply -f https://raw.githubusercontent.com/cloudflare/origin-ca-issuer/${var.crds_version}/deploy/crds/cert-manager.k8s.cloudflare.com_originissuers.yaml
#     EOT
#   }

#   provisioner "local-exec" {
#     # Aplica el segundo CRD usando el mismo archivo temporal de kubeconfig
#     command = "KUBECONFIG=/tmp/kubeconfig kubectl apply -f https://raw.githubusercontent.com/cloudflare/origin-ca-issuer/${var.crds_version}/deploy/crds/cert-manager.k8s.cloudflare.com_clusteroriginissuers.yaml"
#   }
# }

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

  values     = [file("${path.module}/values.yaml")]

  # values = [
  #   templatefile("${path.module}/values.yaml.tpl", {
  #     harbor_admin_password = var.harbor_admin_password,
  #     domain_name           = var.domain_name,
  #     dash_domain_name      = var.dash_domain_name,
  #     environment           = var.environment

  #   })
  # ]
}

provider "kubernetes" {
  config_path = "~/.kube/config"  # Ruta al kubeconfig (personaliza si es necesario)
}

# Crear el Secret
resource "kubernetes_secret" "origin_ca_issuer_secret" {
  metadata {
    name      = var.helm_release_name
    namespace = var.namespace_name
  }
  data = {
    key = var.key
  }
  type = "Opaque"
}

# Crear el ClusterOriginIssuer
resource "kubernetes_manifest" "cluster_origin_issuer" {
  manifest = {
    apiVersion = "cert-manager.k8s.cloudflare.com/v1"
    kind       = "ClusterOriginIssuer"
    metadata = {
      name      = var.helm_release_name
      namespace = var.namespace_name
    }
    spec = {
      auth = {
        serviceKeyRef = {
          name = kubernetes_secret.origin_ca_issuer_secret.metadata[0].name
          key  = "key"
        }
      }
      requestType = "OriginECC"
    }
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