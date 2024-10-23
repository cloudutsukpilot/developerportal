resource "azurerm_bastion_host" "azBastionsHost" {
  for_each            = { for k, v in local.bastion_list : k => v }
  name                = "${each.key}-bastion-host"
  location            = each.value.location
  resource_group_name = data.azurerm_resource_group.asp_rg[each.value.rg].name
  sku                 = "Standard"
  tunneling_enabled   = true

  ip_configuration {
    name                 = "configuration"
    subnet_id            = azurerm_subnet.azsubnets["${each.key}-AzureBastionSubnet"].id
    public_ip_address_id = azurerm_public_ip.azBastionsPIP["${each.key}"].id
  }

  tags = var.extra_tags

}

resource "azurerm_public_ip" "azBastionsPIP" {
  for_each            = { for k, v in local.bastion_list : k => v }
  name                = "${each.key}-bastion-pip"
  location            = each.value.location
  resource_group_name = data.azurerm_resource_group.asp_rg[each.value.rg].name
  allocation_method   = "Static"
  sku                 = "Standard"
  tags                = var.extra_tags
}

resource "azurerm_network_interface" "bastion_nic" {
  for_each            = { for k,v in local.bastion_vm_list: "${v.vnet}-${v.subnet}" => v}
  name                = "${each.key}-bastionvm-nic"
  location            = each.value.location
  resource_group_name = data.azurerm_resource_group.asp_rg[each.value.rg].name

  ip_configuration {
    name                          = "${each.key}-bastionvm-privateip"
    subnet_id                     = azurerm_subnet.azsubnets["${each.value.vnet}-${each.value.subnet}"].id
    private_ip_address_allocation = "Dynamic"
  }
  tags                = var.extra_tags
}

resource "azurerm_linux_virtual_machine" "bastion_vm" {
  for_each            = { for k,v in local.bastion_vm_list: "${v.vnet}-${v.subnet}" => v}
  name                  = "${each.key}-bastion-vm"
  location              = each.value.location
  resource_group_name   = data.azurerm_resource_group.asp_rg[each.value.rg].name
  network_interface_ids = [azurerm_network_interface.bastion_nic[each.key].id]
  size                  = each.value.size
  admin_username        = each.value.username
  source_image_reference {

      publisher = each.value.source_image_reference.publisher
      offer     = each.value.source_image_reference.offer
      sku       = each.value.source_image_reference.sku
      version   = each.value.source_image_reference.version
  }
  os_disk {
      caching              = each.value.os_disk.caching
      storage_account_type = each.value.os_disk.storage_account_type
      disk_size_gb         = each.value.os_disk.disk_size_gb
  }
  admin_ssh_key {
    username    = each.value.username
    public_key  = var.bastion_vm_public_key
  }
  identity {
    type = "SystemAssigned"
  }
  secure_boot_enabled = false
  vtpm_enabled        = false
  custom_data    = base64encode(var.custom_data) #data.template_file.linux-vm-cloud-init.rendered
  tags = var.extra_tags
  lifecycle {
    ignore_changes = [
      tags,
      custom_data,
      identity,
      boot_diagnostics
    ]
  }
}

resource "azurerm_virtual_machine_extension" "aad_login" {
  for_each            = { for k,v in local.bastion_vm_list: k => v}
  name                 = "AADSSHLogin"
  virtual_machine_id   = azurerm_linux_virtual_machine.bastion_vm["${each.value.vnet}-${each.value.subnet}"].id
  publisher            = "Microsoft.Azure.ActiveDirectory"
  type                 = "AADSSHLoginForLinux" # For Windows VMs: AADLoginForWindows
  type_handler_version = "1.0" # There may be a more recent version
  auto_upgrade_minor_version = true
  depends_on = [ azurerm_linux_virtual_machine.bastion_vm ]
}

data "azurerm_subscription" "primary" {
}

data "azurerm_role_definition" "VMAdmin" {
  name = "Virtual Machine Administrator Login"
  scope  = data.azurerm_subscription.primary.id
}

resource "azurerm_role_assignment" "VMAdmin_Assignment" {
  for_each            = { for k,v in local.bastion_vm_role_assignment_list: "${v.vmname}-${v.objectid}" => v}
  scope              = azurerm_linux_virtual_machine.bastion_vm[each.value.vmname].id
  role_definition_id = "${data.azurerm_role_definition.VMAdmin.id}"
  principal_id       = each.value.objectid
}