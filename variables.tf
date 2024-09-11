#
# Contextual Fields
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

#
# External DNS
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