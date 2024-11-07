output "role_assignments_output" {
  description = "The name of the aks clusters"
  value = { 
    for roleassignment in azurerm_role_assignment.role_assignments : roleassignment.name =>{
      name = roleassignment.name
    }
  }
}
