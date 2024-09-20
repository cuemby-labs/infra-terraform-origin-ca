#
# CRDs Variables
#

variable "crds_version" {
  description = "Version of the OriginIssuer CRD"
  type        = string
  default     = "v0.9.0"
}

variable "kubeconfig_content" {
  type        = string
  description = "The content of the kubeconfig file."
}

#
# External DNS Variables
#

variable "namespace_name" {
  description = "The namespace where resources will be created, it have to be the same as cert-manager."
  type        = string
  default     = "origin-ca"
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