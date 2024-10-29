resource "azurerm_virtual_network" "azvnet" {

  for_each            = var.virtual_networks

  name                = each.value.name
  address_space       = each.value.address_space
  location            = each.value.location
  resource_group_name = each.value.resource_group_name
  tags                = each.value.tags
}
