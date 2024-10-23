resource "azurerm_resource_group" "rg" {
  for_each = var.resource_groups

  name     = each.key
  location = each.value

  tags = lookup(var.tags, each.key, {})  # Lookup tags for the specific resource group
}