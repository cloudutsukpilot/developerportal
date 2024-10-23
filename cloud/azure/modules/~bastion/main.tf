resource "azurerm_bastion_host" "azBastionsHost" {
  for_each            = { for k,v in local.bastion_details: k=> v}
  name                = "${var.env}-${var.common_location}-${each.key}-bastion"
  location            = var.common_location
  resource_group_name = var.common_resource_group
  sku                 = "Standard"
  tunneling_enabled   = true

  ip_configuration {
    name                 = "configuration"
    subnet_id            = each.value.subnetid
    public_ip_address_id = each.value.ipaddressid
  }

  tags                = var.extra_tags

  depends_on = [
    #azurerm_public_ip.azBastionsPIP
    data.azurerm_public_ip.azBastionPIPs
  ]
}

resource "azurerm_public_ip" "azBastionsPIP" {
    for_each            = { for k,v in local.bastion_list: k=> v}
    name                = "${var.global.environment}-${var.global.location}-bastion-PIP"
    #name                = "${var.global.environment}-${var.global.location}-${each.value.subnetname}-bastion-PIP"
    location            = var.global.location
    resource_group_name = "${var.global.environment}-baseNetworkInfrastructure"
    allocation_method   = "Static"
    sku                 = "Standard"
    tags                = var.extra_tags
}