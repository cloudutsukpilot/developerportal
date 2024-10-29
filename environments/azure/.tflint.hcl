# explicit "terraform" plugin with version + source
plugin "terraform" {
    enabled = true
    version = "0.2.2"
    source  = "github.com/terraform-linters/tflint-ruleset-terraform"
}

# ...and the "azurerm" plugin
plugin "azurerm" {
    enabled = true
    version = "0.22.0"
    source  = "github.com/terraform-linters/tflint-ruleset-azurerm"
}

# rules follow here
