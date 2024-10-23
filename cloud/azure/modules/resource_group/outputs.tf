output "resource_group_output" {
  description = "The name of the resource group"
  value = { for rg in azurerm_resource_group.rg : rg.name => rg.location }
}

