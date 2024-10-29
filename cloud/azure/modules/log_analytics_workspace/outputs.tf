output "workspaces_output" {
  description = "The name of the subnets"
  value = { 
    for workspace in azurerm_log_analytics_workspace.workspaces : workspace.name =>{
      name = workspace.name
    }
  }
}
