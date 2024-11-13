#
# Manifests resoruces
#

data "http" "manifest_url" {
  for_each = toset(var.manifests_urls)
  url      = each.value
}

data "kubectl_file_documents" "manifest_files" {
  for_each = data.http.manifest_url
  content  = each.value.rendered
}

resource "kubectl_manifest" "install_manifest_files" {
  for_each  = { for index, doc in data.kubectl_file_documents.manifest_files : index => doc }
  yaml_body = each.value
}

#
# Walrus Information
#

locals {
  context = var.context
}