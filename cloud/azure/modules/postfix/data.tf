data "azurerm_subnet" "postfix-subnet" {
  for_each             = { for subnets in local.subnet_list : "${subnets.virtual_network_name}-${subnets.subnetname}" => subnets }
  name                 = each.value.subnetname
  virtual_network_name = each.value.virtual_network_name
  resource_group_name  = data.azurerm_resource_group.journaling_rg[each.value.rg].name
  depends_on           = [data.azurerm_resource_group.journaling_rg]
}
data "azurerm_resource_group" "journaling_rg" {
  for_each = { for rg, rgs in local.rg_list : rg => rgs }
  name     = each.key
}