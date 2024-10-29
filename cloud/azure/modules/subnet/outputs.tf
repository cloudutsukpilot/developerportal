output "subnets_output" {
  description = "The name of the subnets"
  value = { 
    for subnets in azurerm_subnet.azsubnets : subnets.name =>{
      name = subnets.name
    }
  }
}
