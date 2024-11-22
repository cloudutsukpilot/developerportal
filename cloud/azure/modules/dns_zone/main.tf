resource "azurerm_dns_zone" "dns_zone" {
  for_each =  var.dns_zones

  name                = each.value.name
  resource_group_name = each.value.resource_group_name
  tags     = each.value.tags
}