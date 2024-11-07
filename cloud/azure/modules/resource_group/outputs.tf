output "resource_group_output" {
  description = "The resource group outputs"
  value = { 
    for rg in azurerm_resource_group.rg : rg.name => {
      name     = rg.name
      location = rg.location
      id       = rg.id
    }
  }
}