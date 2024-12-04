# Origin-CA Template

Terraform module which deploys Origin-CA on any kubernetes cluster.

## Usage

```hcl
module "origin_ca" {
  source          = "./modules/origin-ca"                   # Path to the External-DNS module

  namespace_name  = "origin-ca"                             # The namespace where Origin-CA will be created
  image_version   = "cloudflare/origin-ca-issuer:v0.9.0"    # origin-ca-issuer version.
  key             = "secret key for cloudflare"             # secret key for cloudflare
  manifests_urls  = [url1, url2]                            # List of HTTP RAW URLs for kubernetes manifest

  resources = {
    limits = {
      cpu    = "1"
      memory = "512Mi"
    }
    requests = {
      cpu    = "1"
      memory = "512Mi"
    }
  }
}
```

## Examples

- ...
- ...

## Contributing

Please read our [contributing guide](./docs/CONTRIBUTING.md) if you're interested in contributing to Walrus template.

<!-- BEGIN_TF_DOCS -->
## Requirements

Previous Ingress-NGINX install needs the CRDs to be install before, you can use the [Walrus Kubernetes template](https://github.com/cuemby-labs/infra-terraform-kubernetes-manifest) or install them manualy from the [CloudFlare site](https://github.com/cloudflare/origin-ca-issuer/tree/trunk/deploy/crds)

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.5.7 |
| <a name="requirement_kubernetes"></a> [kubernetes](#requirement\_kubernetes) | >= 2.23.0 |
| <a name="requirement_helm"></a> [helm](#requirement\_helm) | >= 2.11.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_terraform"></a> [terraform](#provider\_terraform) | >= 1.5.7 |
| <a name="provider_kubernetes"></a> [kubernetes](#provider\_kubernetes) | >= 2.23.0 |
| <a name="provider_helm"></a> [helm](#provider\_helm) | >= 2.11.0 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="kubernetes_manifest"></a> [kubernetes_manifest](#module\_kubernetes_manifest) | "github.com/cuemby-labs/infra-terraform-kubernetes-manifest?ref=v1.0.1" | v1.0.1 |

## Resources

| Name | Type |
|------|------|
| [kubernetes_manifest.test](https://registry.terraform.io/providers/alekc/kubectl/latest/docs/resources/kubectl_manifest) | resource |
| [kubernetes_namespace.example](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/namespace) | resource |
| [template_file.init](https://registry.terraform.io/providers/hashicorp/template/latest/docs/data-sources/file) | data |
| [kubectl_file_documents.docs](https://registry.terraform.io/providers/gavinbunney/kubectl/latest/docs/data-sources/kubectl_file_documents) | data |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_namespace_name"></a> [namespace_name](#input_namespace_name) | Namespace where Origin-CA will be installed. | string | "origin-ca" | no |
| <a name="input_image_version"></a> [image_version](#input_image_version) | origin-ca-issuer version. | string | "cloudflare/origin-ca-issuer:v0.9.0" | no |
| <a name="input_key"></a> [key](#input_key) | Secret key for cloudflare. | string | "" | yes |
| <a name="input_manifests_urls"></a> [manifests_urls](#input_manifests_urls) | URLs list from the raw manifests. | list(string) | '"[url1, url2]"' | yes |
| <a name="input_resources"></a> [resources](#input_resources) | Resource limits and requests for Cert-Manager pods. | `map(map(string))` | `"See example"` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_walrus_environment_id"></a> [walrus\_environment\_id](#output\_walrus\_environment\_id) | The id of environment where deployed in Walrus. |
| <a name="output_walrus_environment_name"></a> [walrus\_environment\_name](#output\_walrus\_environment\_name) | The name of environment where deployed in Walrus. |
| <a name="output_walrus_project_id"></a> [walrus\_project\_id](#output\_walrus\_project\_id) | The id of project where deployed in Walrus. |
| <a name="output_walrus_project_name"></a> [walrus\_project\_name](#output\_walrus\_project\_name) | The name of project where deployed in Walrus. |
| <a name="output_walrus_resource_id"></a> [walrus\_resource\_id](#output\_walrus\_resource\_id) | The id of resource where deployed in Walrus. |
| <a name="output_walrus_resource_name"></a> [walrus\_resource\_name](#output\_walrus\_resource\_name) | The name of resource where deployed in Walrus. |
<!-- END_TF_DOCS -->

## License

Copyright (c) 2023 [Seal, Inc.](https://seal.io)

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at [LICENSE](./LICENSE) file for details.

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
