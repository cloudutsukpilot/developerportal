output "virtual_network_output" {
  description = "The name of the virtual networks"
  value = { 
    for vnet in azurerm_virtual_network.azvnet : vnet.name =>{
      name = vnet.name
    }
  }
}
