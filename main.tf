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
  template = file("${path.module}/values.yaml.tpl")
  vars     = {
    namespace_name = var.namespace_name,
    key            = var.key,
    image_version  = var.image_version,
    request_memory = var.resources["requests"]["memory"],
    limits_memory  = var.resources["limits"]["memory"],
    request_cpu    = var.resources["requests"]["cpu"],
    limits_cpu     = var.resources["limits"]["cpu"]
  }
}

data "kubectl_file_documents" "manifest_files" {
  content = data.template_file.manifest_template.rendered
}

resource "kubectl_manifest" "apply_manifests" {
  depends_on = [ module.kubernetes_manifest ]

  for_each  = data.kubectl_file_documents.manifest_files.manifests
  yaml_body = each.value
}

#
# HPA
#

data "template_file" "hpa_manifest_template" {
  template = file("${path.module}/hpa.yaml.tpl")
  vars     = {
    namespace_name            = var.namespace_name,
    min_replicas              = var.hpa_config.min_replicas,
    max_replicas              = var.hpa_config.max_replicas,
    target_cpu_utilization    = var.hpa_config.target_cpu_utilization,
    target_memory_utilization = var.hpa_config.target_memory_utilization
  }
}

data "kubectl_file_documents" "hpa_manifest_files" {
  content = data.template_file.hpa_manifest_template.rendered
}

resource "kubectl_manifest" "apply_hpa_manifests" {
  for_each  = data.kubectl_file_documents.hpa_manifest_files.manifests
  yaml_body = each.value

  lifecycle {
    ignore_changes = [yaml_body]
  }

  depends_on = [data.kubectl_file_documents.hpa_manifest_files]
}

#
# Walrus Information
#

locals {
  context = var.context
}

module "submodule" {
  source = "./modules/submodule"

  message = "Hello, submodule"
}