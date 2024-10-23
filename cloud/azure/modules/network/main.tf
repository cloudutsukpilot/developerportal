resource "azurerm_virtual_network" "azvnet" {
  for_each            = { for vnet, vnetdata in local.vnet_list : vnetdata.vnetname => vnetdata }
  name                = each.value.vnetname
  address_space       = each.value.vnet_address_space
  location            = each.value.location
  resource_group_name = data.azurerm_resource_group.asp_rg[each.value.rg].name
  tags                = var.extra_tags
}

resource "azurerm_subnet" "azsubnets" {
  for_each             = { for subnets in local.subnet_list : "${subnets.virtual_network_name}-${subnets.subnetname}" => subnets }
  name                 = each.value.subnetname
  resource_group_name  = data.azurerm_resource_group.asp_rg[each.value.rg].name
  virtual_network_name = each.value.virtual_network_name
  address_prefixes     = each.value.address_prefixes

  service_endpoints = each.value.serviceendpoints

  depends_on = [
    azurerm_virtual_network.azvnet
  ]
}

#Vnet Peering from Hub to Spokes
resource "azurerm_virtual_network_peering" "firewalltoapp" {
  for_each                  = { for vnet, vnetdata in local.vnet_list : "${local.hub_vnet[0].vnetname}-TO-${vnetdata.vnetname}" => vnetdata if vnetdata.type != "hub"}
  name                      = each.key
  resource_group_name       = local.hub_vnet[0].rg
  virtual_network_name      = local.hub_vnet[0].vnetname
  remote_virtual_network_id = azurerm_virtual_network.azvnet[each.value.vnetname].id
  depends_on                = [azurerm_subnet.azsubnets]
}

#Vnet Peering from Spokes to Hub
resource "azurerm_virtual_network_peering" "apptofirewall" {
  for_each                  = { for vnet, vnetdata in local.vnet_list : "${vnetdata.vnetname}-TO-${local.hub_vnet[0].vnetname}" => vnetdata if vnetdata.type != "hub"}
  name                      = each.key
  resource_group_name       = data.azurerm_resource_group.asp_rg[each.value.rg].name
  virtual_network_name      = each.value.vnetname
  remote_virtual_network_id = azurerm_virtual_network.azvnet[local.hub_vnet[0].vnetname].id
  depends_on                = [azurerm_subnet.azsubnets]
}