terraform {
  required_version = ">= 1.2"
  #experiments = [module_variable_optional_attrs]
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">= 3.88.0"
    }
    sops = {
      source = "carlpett/sops"
      version = "~> 0.5"
    }
  }
}