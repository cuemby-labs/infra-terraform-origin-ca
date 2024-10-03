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

# Decodificar el YAML en múltiples manifiestos usando manifest_decode_multi
locals {
  manifest_docs = provider::kubernetes::manifest_decode_multi(data.template_file.manifest_template.rendered)
}

# Aplicar los manifiestos usando kubectl
resource "kubectl_manifest" "install_origin_ca" {
  for_each  = { for index, doc in local.manifest_docs : index => doc }

  yaml_body = yamlencode(each.value)
}