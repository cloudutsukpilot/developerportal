remote_state {
  
  backend = "azurerm"

  config = {
    resource_group_name = "terraform-backend"
    storage_account_name = "cloudutsuktfstatestgacc"
    container_name = "terraformstate"
    key            = "${path_relative_to_include()}/terraform.tfstate"
  }
}
