#
# Manifests resoruces
#

provider "http" {}

data "http" "manifests" {
  for_each = { for idx, url in var.manifests_urls : idx => url }

  url = each.value
}

resource "kubectl_manifest" "apply_manifests" {
  for_each = data.http.manifests

  yaml_body = yamldecode(each.value.body)
}

#
# Walrus Information
#

locals {
  context = var.context
}