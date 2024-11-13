#
# CRDs Variables
#

variable "manifests_urls" {
  description = "URLs list from the raw manifests"
  type        = list(string)
  default     = [
    "https://raw.githubusercontent.com/cloudflare/origin-ca-issuer/refs/heads/trunk/deploy/crds/cert-manager.k8s.cloudflare.com_originissuers.yaml",
    "https://raw.githubusercontent.com/cloudflare/origin-ca-issuer/refs/heads/trunk/deploy/crds/cert-manager.k8s.cloudflare.com_clusteroriginissuers.yaml"
  ]
}

#
# Origin CA Variables
#

variable "namespace_name" {
  description = "The namespace where resources will be created."
  type        = string
  default     = "origin-ca"
}

variable "key" {
  description = "Secret key for cloudflare"
  type        = string
  sensitive   = true
  default     = ""
}

variable "helm_release_name" {
  description = "The name of the Helm release."
  type        = string
  default     = "origin-ca-issuer"
}

variable "helm_chart_version" {
  description = "The version of the Helm chart."
  type        = string
  default     = "0.5.5"
}

#
# Walrus Contextual Fields Variable
#

variable "context" {
  description = <<-EOF
Receive contextual information. When Walrus deploys, Walrus will inject specific contextual information into this field.

Examples:
```
context:
  project:
    name: string
    id: string
  environment:
    name: string
    id: string
  resource:
    name: string
    id: string
```
EOF
  type        = map(any)
  default     = {}
}