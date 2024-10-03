locals {
  context = var.context
}

resource "kubernetes_namespace" "origin_ca" {
  metadata {
    name = var.namespace_name
  }
}

data "template_file" "manifest_template" {
  template = file("${path.module}/values.yaml.tpl")
  vars = {
    namespace_name = var.namespace_name,
    key            = var.key,
    image_version  = var.image_version
  }
}

data "kubectl_file_documents" "manifest_files" {
  content = data.template_file.manifest_template.rendered
}

resource "kubectl_manifest" "apply_manifests" {
  for_each  = { for index, doc in data.kubectl_file_documents.manifest_files.documents : index => doc }

  yaml_body = each.value
}