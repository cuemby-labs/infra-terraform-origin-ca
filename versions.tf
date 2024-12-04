terraform {
  required_version = ">= 1.5.7"

  required_providers {
    template = {
      source  = "hashicorp/template"
      version = ">= 2.2.0"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = ">= 2.23.0"
    }
    kubectl = {
      source  = "gavinbunney/kubectl"
      version = ">= 1.14"
    }
  }
}