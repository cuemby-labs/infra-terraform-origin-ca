#
# Manifests resoruces
#

data "http" "manifests" {
  for_each = toset(var.manifests_urls)

  url = each.value
}

resource "kubectl_manifest" "apply_manifests" {
  for_each = data.http.manifests

  yaml_body = each.value.body
}

#
# Walrus Information
#

locals {
  context = var.context
}