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

# # Dividir el contenido del YAML en múltiples documentos (si corresponde)
# data "kubectl_file_documents" "manifest_files" {
#   content = data.template_file.manifest_template.rendered
# }

# # Aplicar los manifiestos usando kubectl
# resource "kubectl_manifest" "install_origin_ca" {
#   for_each  = { for key, doc in data.kubectl_file_documents.manifest_files : key => doc }
  
#   # Concatenar los documentos YAML en un solo string
#   yaml_body = join("\n---\n", [for v in each.value : v])
# }

# Aplicar los manifiestos usando kubectl con manifest_decode_multi
# Decodificar el YAML en múltiples manifiestos usando manifest_decode_multi
locals {
  manifest_docs = provider::kubernetes::manifest_decode_multi(data.template_file.manifest_template.rendered)
}

# Aplicar los manifiestos usando kubectl
resource "kubectl_manifest" "install_origin_ca" {
  for_each  = { for index, doc in local.manifest_docs : index => doc }

  yaml_body = yamlencode(each.value)
}