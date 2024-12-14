#
# CRDs Variables
#

variable "manifests_urls" {
  description = "URLs list from the raw manifests"
  type        = list(string)

  default = [
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

variable "image_version" {
  description = "origin-ca-issuer version."
  type        = string
  default     = "cloudflare/origin-ca-issuer:v0.9.0"
}

variable "key" {
  description = "Secret key for cloudflare"
  type        = string
  sensitive   = true
  default     = ""
}

variable "resources" {
  description = "Resource limits and requests for the Origin-CA Helm release."
  type        = map(map(string))

  default = {
    limits = {
      cpu    = "1000m"
      memory = "512Mi"
    }
    requests = {
      cpu    = "1000m"
      memory = "512Mi"
    }
  }
}

variable "hpa_config" {
  description = "Configuration for the HPA targeting OriginCA Deployment"
  type        = object({
    min_replicas              = number
    max_replicas              = number
    target_cpu_utilization    = number
    target_memory_utilization = number
  })

  default = {
    min_replicas              = 1
    max_replicas              = 3
    target_cpu_utilization    = 80
    target_memory_utilization = 80
  }
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