locals {
  context = var.context
}

# Cargar el archivo YAML local con variables
data "template_file" "manifest_template" {
  template = file("${path.module}/values.yaml.tpl")
  vars = {
    namespace_name = var.namespace_name,
    key            = var.key,
    image_version  = var.image_version
  }
}

# Dividir el contenido del YAML en múltiples documentos (si corresponde)
data "kubectl_file_documents" "manifest_files" {
  content = data.template_file.manifest_template.rendered
}

# Aplicar los manifiestos usando kubectl
resource "kubectl_manifest" "apply_manifests" {
  for_each  = { for index, doc in data.kubectl_file_documents.manifest_files.documents : index => doc }

  # Aplicar el manifiesto al cluster
  yaml_body = each.value
}