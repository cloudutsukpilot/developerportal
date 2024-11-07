resource "azurerm_log_analytics_workspace" "workspaces" {
    for_each            = var.workspaces
  
    name                = each.value.name
    location            = each.value.location
    resource_group_name = each.value.resource_group_name
    sku                 = each.value.sku
    retention_in_days   = each.value.retention_in_days

    tags                = each.value.tags
}