#
# CRDs variables
#

variable "crds_version" {
  description = "Version of the OriginIssuer CRD"
  type        = string
  default     = "v0.9.0"
}

#
# External DNS variables
#

variable "namespace_name" {
  description = "The namespace where resources will be created, it have to be the same as cert-manager."
  type        = string
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