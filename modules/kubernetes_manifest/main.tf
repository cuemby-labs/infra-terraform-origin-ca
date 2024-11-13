#
# Manifests resoruces
#

data "http" "manifest_url" {
 # for_each = toset(var.manifests_urls)
  for_each = { for file, url in var.manifests_urls : file => url }
  url      = each.value
}

# data "kubectl_file_documents" "manifest_files" {
#   for_each = data.http.manifest_url
#   content  = each.value.response_body
# }

resource "kubectl_manifest" "install_manifest_files" {
  # for_each  = { for key, doc in data.kubectl_file_documents.manifest_files : key => doc.documents }
  for_each = { for file, url in var.manifests_urls : file => url }
  # yaml_body = join("\n---\n", each.value)
  yaml_body = data.http.manifest_url[each.key].response_body
}

#
# Walrus Information
#

locals {
  context = var.context
}