resource "azurerm_storage_account" "sg" {
  for_each                 = { for k, v in local.storage_account_list : v.name => v }
  name                     = each.value.name
  resource_group_name      = data.azurerm_resource_group.journaling_rg[each.value.rg].name #"asp-journaling" #data.azurerm_resource_group.journaling_rg[each.value.rg].name
  location                 = each.value.location
  account_tier             = each.value.account_tier
  account_replication_type = each.value.account_replication_type
  #public_network_access_enabled = each.value.public_network_access_enabled
  network_rules {
    bypass                     = ["AzureServices"]
    default_action             = "Deny"
    ip_rules                   = var.global.ssh_whitelisted_ips
    virtual_network_subnet_ids = try([data.azurerm_subnet.azsubnets["${each.value.vnet_allowed}-PostFixSubnet"].id], [])
  }
  tags = local.tags
}

resource "azurerm_storage_share" "fileshare" {
  for_each             = { for k, v in local.storage_account_list : v.file_share_name => v }
  name                 = each.value.file_share_name
  storage_account_name = azurerm_storage_account.sg[each.value.name].name
  quota                = 50
}