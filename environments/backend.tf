# Generated by Terragrunt. Sig: nIlQXj57tbuaRZEa
terraform {
  backend "azurerm" {
    container_name       = "terragrunt"
    key                  = "./terraform.tfstate"
    resource_group_name  = "terraform-backend"
    storage_account_name = "cloudutsuktfstatestgacc"
  }
}
