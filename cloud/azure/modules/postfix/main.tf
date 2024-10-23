resource "azurerm_network_security_group" "postfix_allowed_ips" {
  for_each            = { for k, v in local.postfix_list : "${v.virtual_network_name}-${v.name}" => v }
  name                = "postfix_security_group-${each.value.name}"
  location            = each.value.location
  resource_group_name = data.azurerm_resource_group.journaling_rg[each.value.rg].name

  tags = var.extra_tags
}

resource "azurerm_network_security_rule" "postfix_rule_smtp_allow" {
  for_each            = { for k, v in local.postfix_list : "${v.virtual_network_name}-${v.name}" => v }
  name                        = "postfix_rule_smtp_allow"
  priority                    = 100
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "25"
  source_address_prefixes     = var.global.smtp_whitelisted_ips
  destination_address_prefix  = "*"
  resource_group_name         = data.azurerm_resource_group.journaling_rg[each.value.rg].name
  network_security_group_name = azurerm_network_security_group.postfix_allowed_ips["${each.value.virtual_network_name}-${each.value.name}"].name
}

resource "azurerm_network_security_rule" "postfix_rule_ssh_allow" {
  for_each            = { for k, v in local.postfix_list : "${v.virtual_network_name}-${v.name}" => v }
  name                        = "postfix_rule_ssh_allow"
  priority                    = 101
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "22"
  source_address_prefixes     = var.global.ssh_whitelisted_ips
  destination_address_prefix  = "*"
  resource_group_name         = data.azurerm_resource_group.journaling_rg[each.value.rg].name
  network_security_group_name = azurerm_network_security_group.postfix_allowed_ips["${each.value.virtual_network_name}-${each.value.name}"].name
}


resource "azurerm_public_ip" "pip" {
  for_each            = { for k, v in local.postfix_list : "${v.virtual_network_name}-${v.name}" => v }
  name                = each.key
  location            = each.value.location
  resource_group_name = data.azurerm_resource_group.journaling_rg[each.value.rg].name
  allocation_method   = "Static"
  sku                 = "Standard"
  tags                = var.extra_tags
  domain_name_label   = each.value.domain_name_label

  lifecycle {
    ignore_changes = [
      tags,
      ip_tags,
    ]
  }
}

resource "azurerm_network_interface" "postfix_nic" {
  for_each            = { for k, v in local.postfix_list : "${v.virtual_network_name}-${v.name}" => v }
  name                = each.key
  location            = each.value.location
  resource_group_name = data.azurerm_resource_group.journaling_rg[each.value.rg].name

  ip_configuration {
    name                          = "${each.key}-privateip"
    subnet_id                     = data.azurerm_subnet.postfix-subnet["${each.value.virtual_network_name}-PostFixSubnet"].id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.pip[each.key].id
  }
  tags                = var.extra_tags
}

resource "azurerm_network_interface_security_group_association" "nsgassoc" {
  for_each            = { for k, v in local.postfix_list : "${v.virtual_network_name}-${v.name}" => v }
  network_interface_id      = azurerm_network_interface.postfix_nic["${each.value.virtual_network_name}-${each.value.name}"].id
  network_security_group_id = azurerm_network_security_group.postfix_allowed_ips["${each.value.virtual_network_name}-${each.value.name}"].id
}

resource "azurerm_linux_virtual_machine" "postfix_vm" {
  for_each            = { for k, v in local.postfix_list : "${v.virtual_network_name}-${v.name}" => v }
  name                  = "${each.value.name}-${each.value.virtual_network_name}-${each.value.location}"
  location              = each.value.location
  resource_group_name   = data.azurerm_resource_group.journaling_rg[each.value.rg].name
  network_interface_ids = [azurerm_network_interface.postfix_nic["${each.value.virtual_network_name}-${each.value.name}"].id]
  size                  = each.value.vm_specs.size
  admin_username        = each.value.vm_specs.username
  disable_password_authentication = true
  # admin_password = random_string.random.result
  source_image_reference {

      publisher = each.value.vm_specs.source_image_reference.publisher
      offer     = each.value.vm_specs.source_image_reference.offer
      sku       = each.value.vm_specs.source_image_reference.sku
      version   = each.value.vm_specs.source_image_reference.version
  }
  os_disk {
      caching              = each.value.vm_specs.os_disk.caching
      storage_account_type = each.value.vm_specs.os_disk.storage_account_type
      disk_size_gb         = each.value.vm_specs.os_disk.disk_size_gb
  }
  admin_ssh_key {
    username    = each.value.vm_specs.username
    public_key  = base64decode(each.value.vm_specs.public_key)
  }
  identity {
    type = "SystemAssigned"
  }
  secure_boot_enabled = false
  vtpm_enabled        = false
  #custom_data    = base64encode(var.custom_data) #data.template_file.linux-vm-cloud-init.rendered
  tags = var.extra_tags
}

resource "azurerm_managed_disk" "postfix_data_disk" {
  for_each            = { for k, v in local.postfix_list : "${v.virtual_network_name}-${v.name}" => v }
  name                 = "${each.value.name}-${each.value.virtual_network_name}-${each.value.location}"
  location             = each.value.location
  resource_group_name  = data.azurerm_resource_group.journaling_rg[each.value.rg].name
  storage_account_type = each.value.vm_specs.data_disk.storage_account_type
  create_option        = "Empty"
  disk_size_gb         = each.value.vm_specs.data_disk.disk_size_gb

  tags = var.extra_tags
}

resource "azurerm_virtual_machine_data_disk_attachment" "postfix_vm_disk_attachment" {
  for_each            = { for k, v in local.postfix_list : "${v.virtual_network_name}-${v.name}" => v }
  managed_disk_id    = azurerm_managed_disk.postfix_data_disk["${each.value.virtual_network_name}-${each.value.name}"].id
  virtual_machine_id = azurerm_linux_virtual_machine.postfix_vm["${each.value.virtual_network_name}-${each.value.name}"].id
  lun                = "10"
  caching            = "ReadWrite"
}

resource "random_string" "random" {
  length           = 16
  special          = true
  override_special = "/@£$"
}

resource "azurerm_virtual_machine_extension" "aad_login" {
  for_each            = { for k, v in local.postfix_list : "${v.virtual_network_name}-${v.name}" => v }
  name                 = "AADLogin"
  virtual_machine_id   = azurerm_linux_virtual_machine.postfix_vm["${each.value.virtual_network_name}-${each.value.name}"].id
  publisher            = "Microsoft.Azure.ActiveDirectory"
  type                 = "AADSSHLoginForLinux" # For Windows VMs: AADLoginForWindows
  type_handler_version = "1.0" # There may be a more recent version
  depends_on = [ azurerm_linux_virtual_machine.postfix_vm ]
}



data "azurerm_role_definition" "VMAdmin" {
  name = "Virtual Machine Administrator Login"
}

resource "azurerm_role_assignment" "VMAdmin_Assignment" {
  for_each = { for k, v in local.postfix_iam_role_assignment_list : "${v.name}-${v.objectid}" => v }
  #toset(var.network.postfix.vm_aad_admin_login_group_object_ids)
  scope              = azurerm_linux_virtual_machine.postfix_vm["${each.value.virtual_network_name}-${each.value.name}"].id
  role_definition_id = "/subscriptions/dd757e8d-bbf4-4e1c-b521-be5e98a6ce1a${data.azurerm_role_definition.VMAdmin.id}"
  principal_id       = each.value.objectid
}