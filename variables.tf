#
# External DNS Variables
#

variable "namespace_name" {
  description = "The namespace where resources will be created, it have to be the same as cert-manager."
  type        = string
  default     = "origin-ca"
}

variable "image_version" {
  description = "origin-ca-issuer version."
  type        = string
  default     = "cloudflare/origin-ca-issuer:v0.9.0"
}

variable "key" {
  description = "secret key for cloudflare"
  type        = string
  sensitive   = true
  default     = ""
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