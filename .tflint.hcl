plugin "terraform" {
  enabled = true
  version = "0.5.0"
  source  = "github.com/terraform-linters/tflint-ruleset-terraform"
}

plugin "opa" {
  enabled = false
  version = "0.5.0"
  source  = "github.com/terraform-linters/tflint-ruleset-opa"
}

rule "terraform_unused_declarations" {
  enabled = true
  ignore_variables = ["resources"]
}