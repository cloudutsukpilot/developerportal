data "azurerm_resource_group" "asp_rg" {
  for_each = { for rg, rgs in local.rg_list : rg => rgs }
  name     = each.key
}