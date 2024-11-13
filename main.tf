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

data "template_file" "manifest_template" {
  depends_on = [ module.kubernetes_manifest ]
  
  template = file("${path.module}/values.yaml.tpl")
  vars     = {
    namespace_name = var.namespace_name,
    key            = var.key,
    image_version  = var.image_version
  }
}

data "kubectl_file_documents" "manifest_files" {
  depends_on = [ template_file.manifest_template ]

  content = data.template_file.manifest_template.rendered
}

resource "kubectl_manifest" "apply_manifests" {

  for_each  = data.kubectl_file_documents.manifest_files.manifests
  yaml_body = each.value
}

#
# Walrus Information
#

locals {
  context = var.context
}