output "subnets_output" {
  description = "The name of the subnets"
  value = { 
    for subnet in azurerm_subnet.azsubnets : subnet.name =>{
      id = subnet.id
      name = subnet.name
    }
  }
}
